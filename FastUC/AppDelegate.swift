//
//  AppDelegate.swift
//  FastUC
//
//  Created by Isha Nagireddy on 12/25/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        preloadData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // this function is responsible for preloading the data into core data (data can be found in csv file attached to this project)
    private func preloadData() {
        
        // check if app has already been opened and if data has already been loaded onto device
        let preloadedDataKey = "DataLoaded"
        if UserDefaults.standard.bool(forKey: preloadedDataKey) ==  false {
            
            // locate csv file
            guard let filePath = Bundle.main.path(forResource: "Urgent Cares and Emergency Rooms in MA (FINAL) - Sheet1", ofType: "csv") else {
                print("cannot find data file")
                return
            }
            
            // convert data inside csv file into one long string
            var data = ""
            do {
                data = try String(contentsOfFile: filePath)
            }
            catch {
                print("cannot convert csv file into string")
                return
            }
            
            // create three seperate arrays (one for name of UC, one for lat of UC, and one for lon of UC)
            var name = [String]()
            var latitude = [Double]()
            var longitude = [Double]()
            var care = [String]()
            
            // split the rows into seperate elements
            var rows = data.components(separatedBy: "\n")
            
            //remove header rows
            rows.removeFirst()
            
            //find number of rows
            let length = rows.count
            
            // transfer each elemtn in the csv file into its respective array
            for row in rows {
                
                if row != rows[length - 1] {
                    
                    // name of urgent care
                    let info = row.components(separatedBy: ",")
                    name.append(info[0])
                    
                    // latitude of urgent care
                    latitude.append(Double(info[1])!)
                    
                    //longitude of urgent care
                    longitude.append(Double(info[2])!)
                    
                    // type of care
                    let errorSaving = info[3].components(separatedBy: "\r")
                    care.append(errorSaving[0])
                }
                
            }
            
            // reference to managed object context
            let context = persistentContainer.newBackgroundContext()
            
            // fill the urgentCares array by taking data collected from the three arrays
            context.perform {
                
                for eachElement in 0...(length - 2) {
                    
                    // urgentCare elements will be stored in core data
                    let urgentCare = UrgentCareInfo(context: context)
                    urgentCare.name = name[eachElement]
                    urgentCare.latitude = latitude[eachElement]
                    urgentCare.longitude = longitude[eachElement]
                    urgentCare.type = care[eachElement]
                    
                    // try saving the information into core data
                    do { try context.save()}
                    catch {
                        print("error, cannot transfer data into core data")
                        return
                    }
                    
                }
            }
            
            
            // set preloadedDataKey to true telling computer the data has already been loaded next time the app is opened
            UserDefaults.standard.set(true, forKey: preloadedDataKey)
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FastUC")
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

}
