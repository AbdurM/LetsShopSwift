//
//  Item+CoreDataProperties.swift
//  LetsShop
//
//  Created by ABDUR RAFAY on 9/1/20.
//  Copyright © 2020 ABDUR RAFAY. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var valueInDollars: Double
    @NSManaged public var dateCreated: Date?
    @NSManaged public var bought: Bool
    @NSManaged public var itemKey: String?

}
