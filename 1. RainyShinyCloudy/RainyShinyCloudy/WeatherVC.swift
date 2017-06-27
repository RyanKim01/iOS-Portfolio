//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/5/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit
import CoreLocation

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
    var forecasts: [Forecast]! = []
    var button =  UIButton(type: .custom)
    private let refreshControl = UIRefreshControl()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        //Setting UIButton on top of the navigation bar
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change Location ▼", for: .normal)
        button.addTarget(self, action: #selector(self.presentCitySelectionPage), for: .touchDown)
        let navItem = UINavigationItem(title: "SomeTitle");
        navigationBar.setItems([navItem], animated: false)
        navItem.titleView = button
        
        //Adding refresh control to the tableview
        if #available(iOS 10.0, *) {
            weatherTableView.refreshControl = refreshControl
        } else {
            weatherTableView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Weather Data ...", attributes: [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 12.0)!, NSForegroundColorAttributeName :  UIColor(red: 115/255, green: 182/255, blue: 255/255, alpha: 1)])
       
        //Setting the UITableView delegate & datasource setup
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        currentWeather = CurrentWeather()
        forecast = Forecast(weatherDict: [:])

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customActivityIndicatory(self.view)
        currentWeather.downloadWeatherDetails {
            self.forecast.downloadForecastsData { forecasts in
                self.forecasts = forecasts
                self.weatherTableView.reloadData()
                self.updateMainUI()
                customActivityIndicatory(self.view, startAnimate: false)
            }
        }
    }

    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        button.setTitle("\(currentWeather.cityName) ▼", for: .normal)
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    func presentCitySelectionPage() {
        let citySelectionVC = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: "citySelectionVC") as! CitySelectionVC
        self.present(citySelectionVC, animated:true, completion:nil)
    }
    
    func refreshData() {
        currentWeather.downloadWeatherDetails {
            self.forecast.downloadForecastsData { forecasts in
                self.forecasts = forecasts
                self.weatherTableView.reloadData()
                self.updateMainUI()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}

extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            
            return cell

        } else {
            return WeatherCell()
        }
    }
}

extension WeatherVC: CLLocationManagerDelegate {
    
}
