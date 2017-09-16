//
//  UIViewController+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

public extension CIComponentKit where Base: UIViewController {
    
    var visibleViewController: UIViewController? {
        
        if let presentVC = base.presentedViewController {
            return presentVC.ci.visibleViewController
        }
        
        if base is UITabBarController  {
            return (base as! UITabBarController).selectedViewController?.ci.visibleViewController
        }
        if base is UINavigationController {
            return (base as! UINavigationController).visibleViewController?.ci.visibleViewController
        }
        
        if base.isViewLoaded && (base.view.window != nil) {
            return base
        }else {
            print("UIViewController \(base)")
        }
        return nil
    }
}


public extension UIViewController {
    struct ci {
        public static var appearance: CICUIViewController {
            return CICUIViewController()
        }
    }
}

open class CICUIViewController: UIViewController, CICAppearance {
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.willToggleTheme), name: NSNotification.Name.ci.themeWillToggle, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.didToggleTheme), name: NSNotification.Name.ci.themeWillToggle, object: nil)
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - 主题支持
    open func willToggleTheme() {
        print("CICUIViewController willToggleTheme")
    }
    
    open func didToggleTheme() {
        print("CICUIViewController didToggleTheme")
    }

    
    //MARK: - 
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
