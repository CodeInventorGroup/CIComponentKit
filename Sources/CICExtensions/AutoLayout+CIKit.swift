//
//  AutoLayout+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/26.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit
import Foundation


public protocol CICLayoutPropertyProtocol {
    associatedtype type
    var base: type {get}
    
    static var screenScale: CGFloat { get }
    static var screenHeight: CGFloat { get }
    static var screenSize: CGSize { get }
    var makeSize: CGSize { get }     // eg: 50.makeSize  == CGSize.init(width: 50, height: 50)
    var makeRect: CGRect { get }     // eg: 50.makeRect == CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 50))
}

extension CICLayoutPropertyProtocol {
    public static var screenScale: CGFloat { return UIScreen.main.scale }
    public static var screenSize: CGSize { return UIScreen.main.bounds.size }
    public static var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    public static  var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    public var makeSize: CGSize {
        if base is CGFloat {
            return CGSize.init(width: (base as! CGFloat), height: (base as! CGFloat))
        }else if let base = base as? Double {
            return CGSize.init(width: base, height: base)
        }else if let base = base as? Int {
            return CGSize.init(width: base, height: base)
        }
        return .zero
    }
    public var makeRect: CGRect {
        return CGRect.init(origin: .zero, size: self.makeSize)
    }
}

extension Int: CICLayoutPropertyProtocol {
    public var base: Int { return self }
    public typealias type = Int
}
extension CGFloat: CICLayoutPropertyProtocol {
    public var base: CGFloat { return self }
    public typealias type = CGFloat
}

extension Double: CICLayoutPropertyProtocol {
    public var base: Double { return self }
    public typealias type = Double
}

extension CGSize: CICLayoutPropertyProtocol {
    public var base: CGSize { return self }
    public typealias type = CGSize
}

extension CGSize {
    
    func valid() -> Bool {
        if width > 0 && height > 0 {
            return true
        }
        return false
    }
    
    func add(_ size: CGSize) -> CGSize {
        return CGSize(width: self.width + size.width, height: self.height + size.height)
    }
    
    public func multiply(_ mutiplier: CGFloat) -> CGSize {
        return CGSize.init(width: width * mutiplier, height: height * mutiplier)
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

