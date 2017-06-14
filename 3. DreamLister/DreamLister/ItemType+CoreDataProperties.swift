//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Ryan Kim on 6/13/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
