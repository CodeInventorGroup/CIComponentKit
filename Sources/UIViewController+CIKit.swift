//
//  UIViewController+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

public extension CIComponentKit where Base: UIViewController {
    
    func visibleViewController() -> UIViewController? {
        
        if let presentVC = base.presentedViewController {
            return presentVC.ci.visibleViewController()
        }
        
        if base is UITabBarController  {
            return (base as! UITabBarController).selectedViewController?.ci.visibleViewController()
        }
        if base is UINavigationController {
            return (base as! UINavigationController).visibleViewController?.ci.visibleViewController()
        }
        
        if base.isViewLoaded && (base.view.window != nil) {
            return base
        }else {
            print("UIViewController \(base)")
        }
        return nil
    }
}
