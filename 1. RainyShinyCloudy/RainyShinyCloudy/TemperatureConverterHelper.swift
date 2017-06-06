//
//  TemperatureConverterHelper.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/6/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation

class TemperatureConverterHelper {
    static func convertKelvinToFarenheit(temperatureInKelvin: Double) -> Double {
        let tempInFarenheitPreDivision = (temperatureInKelvin * (9/5) - 459.67)
        let tempInFarenheit = Double(round(10 * tempInFarenheitPreDivision/10))
        return tempInFarenheit
    }
}
