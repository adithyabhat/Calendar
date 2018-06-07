//
//  AgendaDataLoader.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 07/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit
import CoreData

class AgendaDataLoader: NSObject {
    static func isDataLoaded() -> Bool {
        let result = Agenda.fetchAllAgenda()
        if let result = result {
            return result.count > 0
        }
        return false
    }
    
    private static func insertAgenda(context: NSManagedObjectContext,
                                     title: String,
                                     date: Int16,
                                     startTime: NSDate,
                                     endTime: NSDate,
                                     location: String?) {
        let agenda = Agenda(context: context)
        agenda.title = title
        agenda.date = date
        agenda.startTime = startTime
        agenda.endTime = endTime
        agenda.location = location
    }
    
    static func loadSampleData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.context
        //Add sample agenda data
        //1
        insertAgenda(context: context,
                     title: "Meeting with Brad",
                     date: 1,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 10, minute: 30)) as NSDate?)!,
                     location: "Meeting room B167")
        
        //16
        insertAgenda(context: context,
                     title: "Team lunch",
                     date: 16,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 12, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 14, minute: 0)) as NSDate?)!,
                     location: "AB Restaurant")
        
        //23
        insertAgenda(context: context,
                     title: "Meeting with John",
                     date: 23,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 11, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 12, minute: 0)) as NSDate?)!,
                     location: nil)
        
        //12
        insertAgenda(context: context,
                     title: "Breakfast with John",
                     date: 12,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 30)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Discussion on new project",
                     date: 12,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 10, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 11, minute: 00)) as NSDate?)!,
                     location: "Meeting room")
        
        insertAgenda(context: context,
                     title: "Lunch",
                     date: 12,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 12, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 13, minute: 00)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Meeting Jeff",
                     date: 12,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 14, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 15, minute: 00)) as NSDate?)!,
                     location: "Building 5")
        
        insertAgenda(context: context,
                     title: "Review final delivery",
                     date: 12,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     location: nil)
        
        //18
        insertAgenda(context: context,
                     title: "Breakfast with Martin",
                     date: 18,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 30)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Discussion on new project",
                     date: 18,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 10, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 11, minute: 00)) as NSDate?)!,
                     location: "Meeting room")
        
        insertAgenda(context: context,
                     title: "Lunch",
                     date: 18,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 12, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 13, minute: 00)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Meeting Richard",
                     date: 18,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 14, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 15, minute: 00)) as NSDate?)!,
                     location: "Building 5")
        
        insertAgenda(context: context,
                     title: "All hands",
                     date: 18,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 17, minute: 00)) as NSDate?)!,
                     location: "Online")
        
        //20
        insertAgenda(context: context,
                     title: "Service Appointment at BMW",
                     date: 20,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 30)) as NSDate?)!,
                     location: "BMW")
        
        insertAgenda(context: context,
                     title: "Joel Birthday party celebration",
                     date: 20,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 15, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Dinner with client",
                     date: 20,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 20, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 21, minute: 30)) as NSDate?)!,
                     location: "Hotel Vivant")
        
        //8
        insertAgenda(context: context,
                     title: "Meeting with John",
                     date: 8,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 11, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 12, minute: 0)) as NSDate?)!,
                     location: nil)
        
        //14
        insertAgenda(context: context,
                     title: "Service Appointment at BMW",
                     date: 14,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 9, minute: 30)) as NSDate?)!,
                     location: "BMW")
        
        insertAgenda(context: context,
                     title: "Rajesh Birthday party celebration",
                     date: 14,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 15, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     location: "Cafetaria")
        
        insertAgenda(context: context,
                     title: "Meeting Richard",
                     date: 14,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 14, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 15, minute: 00)) as NSDate?)!,
                     location: "Building 5")
        
        insertAgenda(context: context,
                     title: "All hands",
                     date: 14,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 16, minute: 00)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 17, minute: 00)) as NSDate?)!,
                     location: "Online")
        
        insertAgenda(context: context,
                     title: "Dinner with client",
                     date: 14,
                     startTime: (Calendar.current.date(from: DateComponents(hour: 20, minute: 30)) as NSDate?)!,
                     endTime: (Calendar.current.date(from: DateComponents(hour: 21, minute: 30)) as NSDate?)!,
                     location: "Hotel Vivant")
        
        appDelegate.saveContext()
    }
}
