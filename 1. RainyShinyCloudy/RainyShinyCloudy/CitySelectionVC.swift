//
//  CitySelectionVC.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/6/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class CitySelectionVC: UIViewController {
    @IBOutlet weak var cityTableView: UITableView!

    let cities = ["Current Location", "Abbey Wood", "Saint-Merri"]
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    @IBAction func closeBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}

extension CitySelectionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? CityCell {
            cell.configureCell(cityName: cities[indexPath.row])
            return cell
        } else {
            return CityCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeCityLocation(cityName: cities[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
