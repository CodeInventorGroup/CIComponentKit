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

