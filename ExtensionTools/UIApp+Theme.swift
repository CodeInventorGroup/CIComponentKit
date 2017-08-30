//
//  UIColor+Theme.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

let CIComponentKitThemeToggleNotifier = NSNotification.Name.init("CIComponentKitThemeNotifier")

public struct CIComponentKitTheme {
    
    public init() {
    }
    
    // 当前主题
    public static var currentTheme = CIComponentKitTheme() {
        didSet {
//            CILoadingHUD.default.show("Toggle theme...", blurStyle: .light, layoutStyle: .top)
        }
    }
    
    // system colors
    public static var originTheme = CIComponentKitTheme()
    
    // the resource of theme, 主题的来源
    public enum CIComponentKitThemeSource {
        
        case plist(URL)
        
        case theme(CIComponentKitTheme)
    }
    
    // switch theme from theme's source
    public static func switchTheme(_ themeSource: CIComponentKitThemeSource) -> Swift.Void {
        switch themeSource {
        case .theme(let theme):
            
            CIComponentKitTheme.currentTheme = theme
            
            break
        case .plist(let themeUrl):
            print(themeUrl)
            break
        }
    }
    
    // theme's id
    public var identifier = "Default"
    
    // UILabel | UIButton
    public var textColor = UIColor.black
    
    // alert | toast | loading | UITabbarButtonItem
    public var tintColor = UIColor.ci.hex(hex: 0x5CC9F5)
    
    public var confirmColor = UIColor.ci.hex(hex: 0x5CC9F5)
    
    public var cancelColor = UIColor.ci.rgb(red: 175, green: 174, blue: 169)
    
    public var navigationBarLeftColor = UIColor.ci.rgb(red: 209, green: 211, blue: 138)
    
}



// MARK: - CIComponentKitTheme Source 主题来源
public extension CIComponentKitTheme {
    

}


// MARK: - 切换主题 toggle theme
public extension CIComponentKitTheme {
    
    // the transition of toggling theme , 切换主题的过度动画
    public enum CIComponentKitThemeTransition {
        case None
        case progress(() -> ())
    }
    
    public enum CIComponentKitSourceError: Error {
        case neterror(URLResponse)
        case other
    }
    
    
    public func renderTheme(_ animation: CIComponentKitThemeTransition = .None) {
        
        // post a notification
        NotificationCenter.default.post(name: CIComponentKitThemeToggleNotifier, object: self, userInfo: nil)
        
        CIComponentKitTheme.currentTheme = self
        if let currentViewController = UIApplication.shared.keyWindow?.rootViewController?.ci.visibleViewController() {
            print("----------------toggle theme------------------")
            print("---------- theme identifier: \(self.identifier) ----")
            
            currentViewController.navigationController?.navigationBar.tintColor = self.tintColor
            currentViewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: navigationBarLeftColor], for: .normal)
            
        }
        
        CILoadingHUD.appearance().tintColor = self.tintColor
        
        CIComponentAppearance<UIView>.appearance.tintColor = self.tintColor
        CIComponentAppearance<UINavigationBar>.appearance.barTintColor = self.navigationBarLeftColor

    }
    
    
    public static func renderTheme(_ animation: CIComponentKitThemeTransition, _ theme: CIComponentKitTheme = CIComponentKitTheme.originTheme) throws -> Swift.Void {
        
        theme.renderTheme()
        
        
        throw CIComponentKitSourceError.neterror(URLResponse())
    }
}
