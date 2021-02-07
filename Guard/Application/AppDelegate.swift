//
//  AppDelegate.swift
//  Guard
//
//  Created by Idan Moshe on 19/08/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint(Locale.preferredLanguages)
                
        UIView.appearance().semanticContentAttribute = Localization.semanticContentAttribute()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if !UIDevice.current.isBatteryMonitoringEnabled {
            UIDevice.current.isBatteryMonitoringEnabled = true
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        if PreferenceManager.isTutorialCompleted  {            
            if PreferenceManager.isVisitsEnabled {
                LocationService.shared.startMonitoringVisits()
            }
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let initialViewController: UIViewController = mainStoryboard.instantiateInitialViewController() {
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        } else {
            let tutorialStoryboard = UIStoryboard(name: "Tutorial", bundle: nil)
            if let initialViewController: UIViewController = tutorialStoryboard.instantiateInitialViewController() {
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        FirebaseApp.configure()
        
        if Crashlytics.crashlytics().isCrashlyticsCollectionEnabled() == false {
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }
        
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // com.apple.UIKit.activity.Mail
        /*
        let places: [[String: Any]] = PersistentStorage.exportAll()
        guard let filePath: String = BackupService.shared.save(value: places, fileName: "places") else {
            debugPrint("Failed to export \(places.count) places")
            return
        }
        
        debugPrint("Successfully export \(places.count) places to: \(filePath)")
        
        guard let window: UIWindow = self.window, let rootViewController = window.rootViewController else { return }
        let url = URL(fileURLWithPath: filePath)
        
        rootViewController.openShareViewController(activityItems: [url]) { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
            debugPrint("")
        }
 */
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.saveContext()
        
        /* do {
            try PersistentStorage.importFromPlist(fileName: "places",
                                                   entityName: "Location",
                                                   context: self.managedObjectContext())
        } catch let error {
            debugPrint(error)
        } */
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Guard")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Addons
    
    func managedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}

extension AppDelegate {
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return PersistentStorage.application(app, open: url, options: options)
    }
    
}
