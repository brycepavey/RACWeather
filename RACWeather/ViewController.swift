//
//  ViewController.swift
//  RACWeather
//
//  Created by Bryce Pavey on 6/11/2015.
//  Copyright © 2015 Bryce Pavey. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    private var weather: Weather?
    private let (melbProducer, melbObserver) = SignalProducer<String, NoError>.buffer(1)
    private let (sydProducer, sydObserver) = SignalProducer<String, NoError>.buffer(1)
    private let (hobProducer, hobObserver) = SignalProducer<String, NoError>.buffer(1)
    private let (allProducer, allObserver) = SignalProducer<(), NoError>.buffer(1)
    
    @IBOutlet weak var melbConditions: UILabel!
    @IBOutlet weak var sydConditions: UILabel!
    @IBOutlet weak var hobConditions: UILabel!
    
    func getRandomWeather() -> String {
        let rand = Int(arc4random_uniform(UInt32(weather!.conditions.count)))
        return weather!.conditions[rand]
    }
    
    
    @objc func fetchMelb() {
        melbObserver.sendNext(self.getRandomWeather())
    }
    
    @objc func fetchSyd() {
        sydObserver.sendNext(self.getRandomWeather())
    }
    
    @objc func fetchHob() {
        hobObserver.sendNext(self.getRandomWeather())
    }
    
    @objc func fetchAllWeather() {
        allObserver.sendNext()
    }
    
    func allWeatherProcessor(melbSydTuple: (melbMessage: String, sydMessage: String), hobMessage: String) {
        print("sampled melb: \(melbSydTuple.melbMessage)")
        print("sampled syd: \(melbSydTuple.sydMessage)")
        print("sampled syd: \(hobMessage)\n")
        
        melbConditions.text = melbSydTuple.melbMessage
        sydConditions.text = melbSydTuple.sydMessage
        hobConditions.text = hobMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weather = Weather()
        
        allProducer
            .start()
        
        melbProducer
            .skipRepeats()
            .start()
        
        sydProducer
            .skipRepeats()
            .start()
        
        hobProducer
            .skipRepeats()
            .start()
        
        let sampledProducer = melbProducer
            .combineLatestWith(sydProducer)
            .combineLatestWith(hobProducer)
            .sampleOn(allProducer)
        
        sampledProducer
            .on(next: allWeatherProcessor)
            .start()
        
        fetchAllWeather()
        
        // Timers for cities signal producers
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fetchMelb", userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fetchSyd", userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fetchHob", userInfo: nil, repeats: true)

        // Timer for aggregating the latest results
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "fetchAllWeather", userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

