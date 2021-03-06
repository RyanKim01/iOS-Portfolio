//
//  ItemCell.swift
//  DreamLister
//
//  Created by Ryan Kim on 6/14/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var itemType: UILabel!
    
    func configureCell(item: Item) {
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.details
        thumbnailImg.image = item.toImage?.image as? UIImage ?? UIImage(named: "imagePick")
        itemType.text = item.toItemType?.type
    }
}
