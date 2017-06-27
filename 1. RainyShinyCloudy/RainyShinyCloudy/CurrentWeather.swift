//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    private var _cityName: String!
    private var _date: String!
    private var _weatherType: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        get {
            if _cityName == nil {
                _cityName = ""
            }
            return _cityName
        }
        set {
            _cityName = newValue
        }
        
    }
    
    var date: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            let currentDate = dateFormatter.string(from: Date())
            _date = "Today, \(currentDate)"
            
            return _date
        }
        
        set {
            _date = newValue
        }

    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        get {
            if _currentTemp == nil {
                _currentTemp = 0.0
            }
            
            return _currentTemp
        }
        set {
            
            _currentTemp = newValue
        }
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject>{
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        if main == "Mist" || main == "Haze" {
                            self._weatherType = "Clouds"
                        } else {
                            self._weatherType = main.capitalized
                        }
                       
                        print(self._weatherType)
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let currentTemp = main["temp"] as? Double {
                        self._currentTemp = TemperatureConverterHelper.convertKelvinToFarenheit(temperatureInKelvin: currentTemp)
                        print(self._currentTemp)
                    }
                    
                }
            }
            completed()
        }
        
    }
    
}

















