//
//  UIView+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 15/09/2017.
//  Copyright © 2017 club.codeinventor. All rights reserved.
//

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
    
    public enum CICLayoutType {
        case x(CGFloat)
        case y(CGFloat)
        case width(CGFloat)
        case maxWidth(CGFloat)
        case height(CGFloat)
        case maxHeight(CGFloat)
        case none
    }
    
    @discardableResult
    public func x(_ originX: CGFloat = 0.0) -> Self {
        self.frame.origin.x = originX
        return self
    }
    
    @discardableResult
    public func x(equalTo view: UIView) -> Self {
        self.frame.origin.x = view.frame.origin.x
        return self
    }
    
    @discardableResult
    public func y(_ originY: CGFloat = 0.0) -> Self {
        self.frame.origin.y = originY
        return self
    }
    
    @discardableResult
    public func y(equalTo view: UIView) -> Self {
        self.frame.origin.y = view.frame.origin.y
        return self
    }
    
    @discardableResult
    public func width(_ width: CGFloat = 0.0) -> Self {
        self.frame.size.width = width
        return self
    }
    
    @discardableResult
    public func width(equalTo view: UIView) -> Self {
        self.frame.size.width = view.bounds.width
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat = 0.0) -> Self {
        self.frame.size.height = height
        return self
    }
    
    @discardableResult
    public func height(equalTo view: UIView) -> Self {
        self.frame.size.height = view.bounds.width
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
    public func center(equalTo view: UIView) -> Self {
        self.center = view.center
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

extension UIView {
    struct cic {
        public static func spring(_ animation: @escaping (()->()),
                                  duration: TimeInterval = 0.35,
                                  delay: TimeInterval = 0.0,
                                  completion: (()->())? = nil) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                animation()
            }, completion: { (finished) in
                if finished {
                    if let completion = completion {
                        completion()
                    }
                }
            })
        }
    }
}

