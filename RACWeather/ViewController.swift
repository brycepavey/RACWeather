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

    @IBOutlet weak var melbConditions: UILabel!
    @IBOutlet weak var sydConditions: UILabel!
    @IBOutlet weak var hobConditions: UILabel!
    
    func getRandomWeather() -> String {
        let rand = Int(arc4random_uniform(UInt32(weather!.conditions.count)))
        return weather!.conditions[rand]
    }
    
    @objc func fetchWeather() {
        melbObserver.sendNext(self.getRandomWeather())
        sydObserver.sendNext(self.getRandomWeather())
        hobObserver.sendNext(self.getRandomWeather())
        print("\n")
    }
    
    // Melbourne
    func melbWeatherProcessor(message: String) {
        melbConditions.text = message
        print(melbConditions.text)
    }
    
    // Sydney
    func sydWeatherProcessor(message: String) {
        sydConditions.text = message
        print(sydConditions.text)
    }
    
    // Hobart
    func hobWeatherProcessor(message: String) {
        hobConditions.text = message
        print(hobConditions.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weather = Weather()
        
        melbProducer
            .skipRepeats()
            .startWithNext { self.melbWeatherProcessor($0) }
        
        sydProducer
            .skipRepeats()
            .startWithNext { self.sydWeatherProcessor($0) }
        
        hobProducer
            .skipRepeats()
            .startWithNext { self.hobWeatherProcessor($0) }
        
        fetchWeather()
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "fetchWeather", userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

