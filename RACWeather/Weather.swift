//
//  Weather.swift
//  RACWeather
//
//  Created by Bryce Pavey on 6/11/2015.
//  Copyright © 2015 Bryce Pavey. All rights reserved.
//

import UIKit

class Weather: NSObject {
    var conditions: [String]
    
    override init() {
        conditions = ["Sunny", "Thunderstorms", "Rain", "Snow"]
    }
}
