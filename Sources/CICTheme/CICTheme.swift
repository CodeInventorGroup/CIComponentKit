//
//  CICTheme.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit
import Foundation

extension Notification.Name {
    struct cic {
        
        // 切换通知时发出这个通知，post notification when switching theme
        static let themeWillToggle = NSNotification.Name.init("CIComponentKitThemeWillToggleNotifier")
        
        // 切换主题完成之后，post notification When the switching theme is complete
        static let themeDidToggle = NSNotification.Name.init("CIComponentKitThemeDidToggleNotifier")
        
        // 屏幕发生旋转时发出通知
        static let screenDidRotated = NSNotification.Name.init("CIComponentKitThemeDidScreenRotated")
    }
}

public class CIComponentKitTheme {
    
    // 当前主题
    public static var currentTheme = CIComponentKitTheme()

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
        case .plist(let themeUrl):
            print(themeUrl)
        }
    }
    
    /// 主题的详细配置
    public var config = CIComponentKitThemeConfig()

    let blurView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .light))
}

// MARK: - CIComponentKitTheme Source 主题来源
public extension CIComponentKitTheme {

}

// MARK: - 切换主题 toggle theme
public extension CIComponentKitTheme {

    // the transition of toggling theme , 切换主题的过度动画
    public enum CIComponentKitThemeTransition {
        case None
        case blur(UIBlurEffectStyle)
        case progress(() -> Void)
    }
    
    public enum CIComponentKitSourceError: Error {
        case neterror(URLResponse)
        case other
    }

    // showAnimation
    public func showAnimation(_ animation: CIComponentKitThemeTransition) {
        if blurView.superview == nil {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(blurView)
                blurView.size(keyWindow.bounds.size)
                blurView.center(keyWindow.cic.internalCenter)
            }
        }
        switch animation {
        case .blur(let style):
            blurView.effect = UIBlurEffect.init(style: style)
            blurView.isHidden = false
        default:
            break
        }
    }
    
    public func hideAnimation(_ animation: CIComponentKitThemeTransition) {
        blurView.removeFromSuperview()
    }
    
    public func renderTheme(_ animation: CIComponentKitThemeTransition = .None) {
        // post a notification
        NotificationCenter.default.post(name: Notification.Name.cic.themeWillToggle, object: self, userInfo: nil)

        showAnimation(animation)
        
        CIComponentKitThemeCurrentConfig = config
        
        if let currentViewController = UIApplication.shared.keyWindow?.rootViewController?.cic.visibleViewController {
            print("*********************************************************************************")
            print("----------------toggle theme, identifier: \(config.identifier)------------------")
            print("*********************************************************************************")
            
            currentViewController.beginAppearanceTransition(true, animated: true)

            UIApplication.shared.keyWindow?.tintColor = config.tintColor
            currentViewController.navigationController?.navigationBar.tintColor = config.tintColor
            currentViewController.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
                .foregroundColor: config.navigationBarLeftColor],for: .normal)
            
            if let navigationController = currentViewController.navigationController {
//                var navigationBarSize = navigationController.navigationBar.bounds.size
//                navigationBarSize.height += 20
//                currentViewController.navigationController?.navigationBar.setBackgroundImage(UIImage.image(color: config.navigationBarBackgroundColor, size: navigationBarSize), for: .default)
                navigationController.navigationBar.barTintColor = CIComponentKitThemeCurrentConfig.navigationBarBackgroundColor
                navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: config.navigationItemTitleColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: CGFloat(arc4random_uniform(24)))]
            }

            currentViewController.endAppearanceTransition()
        }

        UIView.appearance().tintColor = config.tintColor
        UIWindow.appearance().backgroundColor = config.windowColor
        UINavigationBar.appearance().barTintColor = config.navigationBarBackgroundColor
        UIActivityIndicatorView.appearance().color = config.activityIndicatorColor

        NotificationCenter.default.post(name: Notification.Name.cic.themeDidToggle, object: self, userInfo: nil)
        hideAnimation(animation)
    }

    public static func renderTheme(_ animation: CIComponentKitThemeTransition,
                                   _ theme: CIComponentKitTheme = CIComponentKitTheme.originTheme) throws -> Swift.Void {
        
        theme.renderTheme()
        throw CIComponentKitSourceError.neterror(URLResponse())
    }
}
