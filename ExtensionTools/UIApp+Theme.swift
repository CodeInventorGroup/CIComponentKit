//
//  UIColor+Theme.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

extension Notification.Name {
    struct ci {
        
        // 切换通知时发出这个通知，post notification when switching theme
        static let themeWillToggle = NSNotification.Name.init("CIComponentKitThemeWillToggleNotifier")
        
        // 切换主题完成之后，post notification When the switching theme is complete
        static let themeDidToggle = NSNotification.Name.init("CIComponentKitThemeDidToggleNotifier")
    }
}

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
    
    public var config = CIComponentKitThemeConfig()

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
        NotificationCenter.default.post(name: Notification.Name.ci.themeWillToggle, object: self, userInfo: nil)
        
        CIComponentKitTheme.currentTheme = self
        if let currentViewController = UIApplication.shared.keyWindow?.rootViewController?.ci.visibleViewController {
            print("----------------toggle theme, identifier: \(config.identifier)------------------")
            
            UIApplication.shared.keyWindow?.tintColor = config.tintColor
            currentViewController.navigationController?.navigationBar.tintColor = config.tintColor
            currentViewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: config.navigationBarLeftColor], for: .
                normal)
            
            currentViewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: config.navigationItemTitleColor, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(arc4random_uniform(36)))]
            
        }
        
//        UIView.appearance().tintColor = self.tintColor
//        UINavigationBar.appearance().barTintColor = self.navigationBarLeftColor
        
        
        NotificationCenter.default.post(name: Notification.Name.ci.themeDidToggle, object: self, userInfo: nil)
    }
    
    
    public static func renderTheme(_ animation: CIComponentKitThemeTransition, _ theme: CIComponentKitTheme = CIComponentKitTheme.originTheme) throws -> Swift.Void {
        
        theme.renderTheme()
        
        
        throw CIComponentKitSourceError.neterror(URLResponse())
    }
}
