//
//  UserLocationHelper.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/6/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location()
    
    private init() {
    }
    
    var latitude: Double!
    var longitude: Double!
}
