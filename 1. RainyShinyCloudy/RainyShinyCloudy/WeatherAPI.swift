//
//  WeatherAPI.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation
import CoreLocation

    let API_KEY = "c33afd03290289ce649be2c5fbd12fe8"
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    typealias DownloadComplete = () -> ()
    typealias ForecastDownloadComplete = ([Forecast]) -> ()

    var CURRENT_WEATHER_URL: String {
        return "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=\(API_KEY)"
    }

    var FORCAST_URL: String {
        return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=\(API_KEY)"
    }

    func changeCityLocation(cityName: String) {
        switch cityName {
            case "Current Location":
            locationAuthStatus()
            
            case "Abbey Wood":
                Location.sharedInstance.latitude = 51.5074
                Location.sharedInstance.longitude = 0.1278
            case "Saint-Merri":
                Location.sharedInstance.latitude = 48.8566
                Location.sharedInstance.longitude = 2.3522
            default:
                break
        }
    }


    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print(currentLocation.altitude)
            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
