//
//  UIControl+Callback.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/14.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

private var controlHandlerKey: Int8 = 0

extension UIControl {
    public func addHandler(for controlEvents: UIControlEvents, handler: @escaping (UIControl) -> ()) {
        if let oldTarget = objc_getAssociatedObject(self, &controlHandlerKey) as? CIComponentKitTarget<UIControl> {
            self.removeTarget(oldTarget, action: #selector(oldTarget.sendNext), for: controlEvents)
        }
        
        let target = CIComponentKitTarget<UIControl>(handler)
        objc_setAssociatedObject(self, &controlHandlerKey, target, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }
    
}

internal final class CIComponentKitTarget<Value>: NSObject {
    private let action: (Value) -> ()
    
    internal init(_ action: @escaping (Value) -> ()) {
        self.action = action
    }
    
    @objc
    internal func sendNext(_ receiver: Any?) {
        action(receiver as! Value)
    }
}
