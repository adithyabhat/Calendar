//
//  Agenda+CoreDataClass.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 07/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

public class Agenda: NSManagedObject {
    static func fetchAllAgenda() -> [Agenda]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Agenda")
            let result = try appDelegate?.context.fetch(request)
            return result as? [Agenda]
        } catch {
            print("Fetch Failed")
        }
        return nil
    }
}
