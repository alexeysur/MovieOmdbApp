//
//  AppDelegate.swift
//  MovieOMDbApp
//
//  Created by Alexey on 6/23/19.
//  Copyright © 2019 Alexey. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        customizeAppearance()
        
        return true
    }

    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = .init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white,
                                                            .font : UIFont.init(name: "AvenirNext-DemiBold", size: 22.0)!]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

