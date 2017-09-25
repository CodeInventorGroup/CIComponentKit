//
//  AppDelegate.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit
import CIComponentKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { 
            let theme = CIComponentKitTheme.originTheme
            theme.config.textColor = UIColor.cic.hex(hex: 0xe2e2e2)
            theme.config.mainColor = UIColor.cic.hex(hex: 0xF7F6F6)
            theme.config.tintColor = UIColor.cic.hex(hex: 0xfcfcfc)
            theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
            theme.config.navigationItemTitleColor = UIColor.cic.hex(hex: 0xfcfcfc)
            theme.config.navigationBarBackgroundColor = UIColor.cic.hex(hex: 0x47c1ff)
            theme.renderTheme()
        }
        
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

