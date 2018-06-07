//
//  Agenda+CoreDataProperties.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 07/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//
//

import Foundation
import CoreData

extension Agenda {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Agenda> {
        return NSFetchRequest<Agenda>(entityName: "Agenda")
    }

    @NSManaged public var endTime: NSDate?
    @NSManaged public var location: String?
    @NSManaged public var notes: String?
    @NSManaged public var priority: Int16
    @NSManaged public var startTime: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var date: Int16

}
