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
    
    public var right: CGFloat {
        return base.frame.maxX
    }
    
    public var bottom: CGFloat {
        return base.frame.maxY
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

public enum CICLayoutMaker {
    
    case value(CGFloat)
    case offSet(CGFloat)
    case mutiplier(CGFloat)
    
    case none
}

public enum CICLayoutType {
    case x(CGFloat)
    case y(CGFloat)
    case width(CGFloat)
    case height(CGFloat)
    
    case maxWidth(CGFloat)
    case maxHeight(CGFloat)
    
    case right(CGFloat)
    case bottom(CGFloat)

    case none
}

extension UIView {

    @discardableResult
    public func x(_ originX: CGFloat = 0.0) -> Self {
        self.frame.origin.x = originX
        return self
    }
    
    @discardableResult
    public func x(_ view: UIView, offSet: CGFloat = 0.0, mutiplier: CGFloat = 1.0) -> Self {
        self.frame.origin.x = (view.frame.origin.x + offSet) * mutiplier
        return self
    }
    
    @discardableResult
    public func y(_ originY: CGFloat = 0.0) -> Self {
        self.frame.origin.y = originY
        return self
    }
    
    @discardableResult
    public func bottom(_ value: CGFloat, view: UIView? = nil) -> Self {
        if let toView = view {
            self.y(toView.cic.bottom - value - self.cic.height)
        } else {
            if let superView = self.superview {
                self.y(superView.cic.bottom - value - self.cic.height)
            }
        }
        return self
    }

    @discardableResult
    public func y(_ view: UIView, offSet: CGFloat = 0.0, mutiplier: CGFloat = 1.0) -> Self {
        self.frame.origin.y = (view.frame.origin.y + offSet) * mutiplier
        return self
    }

    @discardableResult
    public func width(_ width: CGFloat = 0.0) -> Self {
        self.frame.size.width = width
        return self
    }
    
    @discardableResult
    public func width(_ view: UIView, offSet: CGFloat = 0.0, mutiplier: CGFloat = 1.0) -> Self {
        self.frame.size.width = (view.bounds.width + offSet) * mutiplier
        return self
    }

    @discardableResult
    public func height(_ height: CGFloat = 0.0) -> Self {
        self.frame.size.height = height
        return self
    }

    @discardableResult
    public func height(_ view: UIView, offSet: CGFloat = 0.0, mutiplier: CGFloat = 1.0) -> Self {
        self.frame.size.height = (view.bounds.height + offSet) * mutiplier
        return self
    }

    @discardableResult
    public func size(_ size: CGSize) -> Self {
        self.frame.size = size
        return self
    }
    
    @discardableResult
    public func size(_ view: UIView, offSet: CGSize = .zero, mutiplier: CGFloat = 1.0) -> Self {
        self.frame.size = view.frame.size.add(offSet).multiply(mutiplier)
        return self
    }

    @discardableResult
    public func center(_ center: CGPoint = .zero) -> Self {
        self.center = center
        return self
    }

    @discardableResult
    public func center(_ view: UIView) -> Self {
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
    public func frame(_ view: UIView, _ offSet: UIEdgeInsets = .zero, mutiplier: CGFloat = 1.0) -> Self {
        self.frame = CGRect.init(x: view.cic.x + offSet.left,
                                 y: view.cic.y + offSet.top,
                                 width: view.cic.width + offSet.left + offSet.right,
                                 height: view.cic.height + offSet.top + offSet.bottom)
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
        public static func spring(_ animation: @escaping (() -> Void),
                                  duration: TimeInterval = 0.35,
                                  delay: TimeInterval = 0.0,
                                  completion: (()->())? = nil) {
            UIView.animate(withDuration: duration,
                           delay: delay,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.4,
                           options: .curveEaseInOut,
                           animations: {
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
