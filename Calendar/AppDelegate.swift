//
//  AppDelegate.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 28/02/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Apply red tint for navigation controller
        UINavigationBar.appearance().tintColor = UIColor.red
        //Preload sample Agenda data
        if AgendaDataLoader.isDataLoaded() == false {
            AgendaDataLoader.loadSampleData()
        }
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calendar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
