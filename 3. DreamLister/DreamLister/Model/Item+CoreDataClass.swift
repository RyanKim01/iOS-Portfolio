//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ryan Kim on 6/13/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation
import CoreData

//@objc(Item)
public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = NSDate()
    }
}
