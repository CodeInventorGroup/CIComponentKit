//
//  AutoLayout+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/26.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

extension CGFloat {
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
}

extension CGSize {
    public static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
}

public enum CICLayoutAttribute {
    
    case left(Any, CGFloat)
    
    case right(Any, CGFloat)
    
    case top(Any, CGFloat)
    
    case bottom(Any, CGFloat)
    
    case leading(Any, CGFloat)
    
    case trailing(Any, CGFloat)
    
    case width(Any, CGFloat)
    
    case height(Any, CGFloat)
    
    case centerX(Any, CGFloat)
    
    case centerY(Any, CGFloat)
    
    case lastBaseline(Any, CGFloat)
    
    
    @available(iOS 8.0, *)
    case firstBaseline(Any, CGFloat)
    
    
    @available(iOS 8.0, *)
    case leftMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case rightMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case topMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case bottomMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case leadingMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case trailingMargin(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case centerXWithinMargins(Any, CGFloat)
    
    @available(iOS 8.0, *)
    case centerYWithinMargins(Any, CGFloat)
    
    case notAnAttribute
}

@available(iOS 9.0, *)
extension UIView {
    
    @discardableResult
    public func sizeAnchor(equalTo value: Any, _ multiplier: CGFloat = 1.0) -> Self {
        if let size = value as? CGSize {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }else if let toItem = value as? UIView {
            self.widthAnchor.constraint(equalTo: toItem.widthAnchor, multiplier: multiplier).isActive = true
            self.heightAnchor.constraint(equalTo: toItem.heightAnchor, multiplier: multiplier).isActive = true
        }else if let toItem = value as? UILayoutGuide {
            self.widthAnchor.constraint(equalTo: toItem.widthAnchor, multiplier: multiplier).isActive = true
            self.heightAnchor.constraint(equalTo: toItem.heightAnchor, multiplier: multiplier).isActive = true
        }
        return self
    }
}

extension NSLayoutConstraint {
    public class func sizeEqual(_ item: Any, toItem: Any, multiplier: CGFloat = 1.0) -> [NSLayoutConstraint] {
        let widthConstraint = NSLayoutConstraint.init(item: item, attribute: .width, relatedBy: .equal, toItem: toItem, attribute: .width, multiplier: multiplier, constant: 0.0)
        let heightConstraint = NSLayoutConstraint.init(item: item, attribute: .height, relatedBy: .equal, toItem: toItem, attribute: .height, multiplier: multiplier, constant: 0.0)
        let leftConstraint = NSLayoutConstraint.init(item: item, attribute: .left, relatedBy: .equal, toItem: toItem, attribute: .left, multiplier: 1.0, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: item, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .top, multiplier: 1.0, constant: 0)
        
        return [leftConstraint, topConstraint, widthConstraint, heightConstraint]
    }
}

