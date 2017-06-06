//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class WeatherVC: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!

    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts: [Forecast]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting UIButton on top of the navigation bar
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Button ▼", for: .normal)
        button.addTarget(self, action: #selector(self.clickTitleOnNavigation), for: .touchDown)
        let navItem = UINavigationItem(title: "SomeTitle");
        navigationBar.setItems([navItem], animated: false)
        navItem.titleView = button
        
        //Setting the UITableView delegate & datasource setup
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        currentWeather = CurrentWeather()
        forecast = Forecast(weatherDict: [:])
        currentWeather.downloadWeatherDetails {
            self.forecast.downloadForecastsData { forecasts in
                self.forecasts = forecasts
                self.updateMainUI()
            }
            
        }
        

    }

    func clickTitleOnNavigation(button: UIButton) {
        print("clicked")
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        
        return cell
    }
}
