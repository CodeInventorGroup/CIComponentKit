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
        
        window = UIWindow().frame(UIScreen.main.bounds)
        
        let rootVC = RootViewController()
        let nav = UINavigationController.init(rootViewController: rootVC)
        nav.navigationBar.isTranslucent = false
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        configBlackTheme()
        
        return true
    }
}

extension AppDelegate {
    func configTheme() {
        let theme = CIComponentKitTheme.originTheme
        theme.config.defaultFont = UIFont.systemFont(ofSize: CGFloat(arc4random_uniform(15)) + 5.0)
        theme.config.textColor = UIColor.cic.hex(hex: 0x323232)
        theme.config.mainColor = UIColor.cic.hex(hex: 0xFAFAFA)
        theme.config.tintColor = UIColor.cic.hex(hex: 0xDF312E)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.random
        theme.config.navigationBarBackgroundColor = UIColor.flat.orange
        theme.config.alertMessageColor = UIColor.cic.random
        theme.config.alertSeparatorColor = UIColor.flat.white
        theme.config.alertBackgroundColor = UIColor.flat.blue
        theme.renderTheme()
    }

    func configBlackTheme() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let theme = CIComponentKitTheme.originTheme
            theme.config.defaultFont = UIFont.cic.systemFont
            theme.config.textColor = UIColor.cic.hex(hex: 0xFFFFFF)
            theme.config.mainColor = UIColor.black
            theme.config.tintColor = UIColor.cic.hex(hex: 0xDF312E)
            theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
            theme.config.navigationItemTitleColor = UIColor.cic.hex(hex: 0xF2F2F2)
            theme.config.navigationBarItemFont = UIFont.cic.preferred(UIFontTextStyle.body)
            theme.config.navigationBarBackgroundColor = UIColor.black
            theme.config.alertMessageColor = UIColor.flat.orange
            theme.config.alertSeparatorColor = UIColor.flat.white
            theme.config.alertBackgroundColor = UIColor.flat.blue
            
            UIView.animate(withDuration: 0.35, animations: {
                theme.renderTheme()
            })
        }
    }
}
