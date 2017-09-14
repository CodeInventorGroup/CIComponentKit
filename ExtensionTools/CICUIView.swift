//
//  UIView+Layout.swift
//  CIComponentKit
//
//  Created by ManoBoo on 11/09/2017.
//  Copyright © 2017 CodeInventor. All rights reserved.
//  UIView一些常用的便捷布局

import UIKit

extension CIComponentKit where Base: UIView {
    
    public var x: CGFloat {
        return base.frame.origin.x
    }
    
    public var y: CGFloat {
        return base.frame.origin.y
    }
    
    public var width: CGFloat {
        return base.bounds.width
    }
    
    public var height: CGFloat {
        return base.bounds.height
    }
    
    public var centerX: CGFloat {
        return base.center.x
    }
    
    public var centerY: CGFloat {
        return base.center.y
    }
    
    public var internalCenterX: CGFloat {
        return base.bounds.width * 0.5
    }
    
    public var internalCenterY: CGFloat {
        return base.bounds.height * 0.5
    }
    
    public var internalCenter: CGPoint {
        return CGPoint.init(x: internalCenterX, y: internalCenterY)
    }
}

extension UIView {
    
    @discardableResult
    public func x(_ originX: CGFloat = 0.0) -> Self {
        self.frame.origin.x = originX
        return self
    }
    
    @discardableResult
    public func y(_ originY: CGFloat = 0.0) -> Self {
        self.frame.origin.y = originY
        return self
    }
    
    @discardableResult
    public func width(_ width: CGFloat = 0.0) -> Self {
        self.frame.size.width = width
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat = 0.0) -> Self {
        self.frame.size.height = height
        return self
    }
    
    @discardableResult
    public func size(_ size: CGSize) -> Self {
        self.frame.size = size
        return self
    }
    
    @discardableResult
    public func center(_ center: CGPoint = .zero) -> Self {
        self.center = center
        return self
    }
    
    @discardableResult
    public func centerX(_ centerX: CGFloat = 0.0) -> Self {
        self.center.x = centerX
        return self
    }
    
    @discardableResult
    public func centerY(_ centerY: CGFloat = 0.0) -> Self {
        self.center.y = centerY
        return self
    }
    
    @discardableResult
    public func frame(_ rect: CGRect) -> Self {
        self.frame = rect
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor = .clear) -> Self {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func userInteractionEnabled(_ isUserInteractionEnabled: Bool = true ) -> Self {
        self.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
}
