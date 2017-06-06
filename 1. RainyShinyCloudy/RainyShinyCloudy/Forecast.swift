//
//  Forecast.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    private var _date:String!
    private var _weatherType: String!
    private var _highTemp: String!
    private var _lowTemp: String!
    
    var date: String {
        get {
            if _date == nil {
                _date = ""
            }
            return _date
        }
        
        set {
            _date = newValue
        }
    }
    
    var weatherType: String {
        get {
            if _weatherType == nil {
                _weatherType = ""
            }
            return _weatherType
        }
        
        set {
            _weatherType = newValue
        }
    }
    
    var highTemp: String {
        get {
            if _highTemp == nil {
                _highTemp = ""
            }
            return _highTemp
        }
        
        set {
            _highTemp = newValue
        }
    }
    
    var lowTemp: String {
        get {
            if _lowTemp == nil {
                _lowTemp = ""
            }
            return _lowTemp
        }
        
        set {
            _lowTemp = newValue
        }
    }
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            if let min = temp["min"] as? Double {
                self._lowTemp = "\(TemperatureConverterHelper.convertKelvinToFarenheit(temperatureInKelvin: min))"
            }
            
            if let max = temp["max"] as? Double {
                self._highTemp = "\(TemperatureConverterHelper.convertKelvinToFarenheit(temperatureInKelvin: max))"
            }
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
       
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        
        
    }
    
    func downloadForecastsData(completed: @escaping ForecastDownloadComplete) {
        Alamofire.request(FORCAST_URL).responseJSON { response in
            let result = response.result
            var forecasts = [Forecast]()
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for item in list {
                        let forcast = Forecast.init(weatherDict: item)
                        forecasts.append(forcast)
                    }
                    print(forecasts)
                }
            }
        completed(forecasts)
        }
    }
}


extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
















