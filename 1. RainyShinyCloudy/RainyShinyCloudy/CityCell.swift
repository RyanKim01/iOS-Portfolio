//
//  CityCell.swift
//  RainyShinyCloudy
//
//  Created by Ryan Kim on 6/6/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!

    func configureCell(cityName: String) {
        cityNameLabel.text = cityName
    }

}
