//
//  CoreDataHelper.swift
//  AIRFD
//
//  Created by Akbarzade on 7/2/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper: NSObject {
    let store: CoreDataStore!
    
    override init() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.store = appDelegate.coreDataStore
        super.init()
        
        //		NSNotificationCenter.defaultCenter().addObserver(self, selector: "contextDidSaveContext:", name: NSManagedObjectContextDidSaveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreDataHelper.contextDidSaveContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.store.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = self.store.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    
    func saveContext(context: NSManagedObjectContext) {
        LogHandler.Log()
        var error: NSError? = nil
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func saveContext(){
        LogHandler.Log()
        self.saveContext(self.backgroundContext!)
    }
    
    func contextDidSaveContext(notification: NSNotification){
        LogHandler.Log()
        let sender = notification.object as! NSManagedObjectContext
        
        if
            sender === self.managedObjectContext {
            print("******** Saved main Context in this thread")
            self.backgroundContext?.performBlock {
                self.backgroundContext?.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else if sender === self.backgroundContext {
            print("******** Saved background Context in this thread")
            self.managedObjectContext.performBlock {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else {
            print("******** Saved Context in other thread")
            self.backgroundContext!.performBlock {
                self.backgroundContext!.mergeChangesFromContextDidSaveNotification(notification)
            }
            self.managedObjectContext.performBlock {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        }
    }
}
