//
//  CIComponentKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit


public protocol CIComponentKitProtocol {
    associatedtype type
    var ci: type {get}
}

public final class CIComponentKit<Base> {
    let base: Base
    
    public init(_ base: Base) {
        self.base = base
    
        // receive the notification of togglling theme
        if base is CIComponentAppearance {
            NotificationCenter.default.addObserver(base, selector: #selector(CIComponentAppearance.willToggleTheme), name: Notification.Name.ci.themeWillToggle, object: nil)
            NotificationCenter.default.addObserver(base, selector: #selector(CIComponentAppearance.didToggleTheme), name: Notification.Name.ci.themeDidToggle, object: nil)
        }
    }
    
    deinit {

    }
}

extension CIComponentKitProtocol {
    public var ci: CIComponentKit<Self> {
        get {
            return CIComponentKit(self)
        }
    }
}


extension UIView: CIComponentKitProtocol {}
extension UIViewController: CIComponentKitProtocol {}


extension CIComponentKit where Base: UIView {
    public var appearance: Base {
        return self.base
    }
}
