//
//  AppDelegate.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-11.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

import SwiftyBeaver
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
        
        
        // or use this for JSON output: console.format = "$J"
        
        // add the destinations to SwiftyBeaver
        
        ///////////////////////////////
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
//        window?.rootViewController = UINavigationController (rootViewController: homeController)
        
        ///////Status bar color
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return false
        }
        
        statusBarView.backgroundColor = UIColor(r: 204, g: 255, b: 255)
        
        
//        window?.rootViewController = UINavigationController(rootViewController: HomeDatasourceController())
        window?.rootViewController = TabBarController()
        
        // Override point for customization after application launch.
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

