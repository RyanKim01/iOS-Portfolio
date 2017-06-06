//
//  WeatherAPI.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation

    let BASE_URL = "http://samples.openweathermap.org/data/2.5/weather?"
    let LATITUTDE = "lat="
    let LONGITUDE = "&lon="
    let APP_ID = "&appid="
    let API_KEY = "c33afd03290289ce649be2c5fbd12fe8"

    typealias DownloadComplete = () -> ()
    typealias ForecastDownloadComplete = ([Forecast]) -> ()

    let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUTDE)-36\(LONGITUDE)130\(APP_ID)\(API_KEY)"

    let FORCAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=-36&lon=130&cnt=10&mode=json&appid=c33afd03290289ce649be2c5fbd12fe8"
