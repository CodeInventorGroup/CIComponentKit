//
//  AutoLayout+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/26.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  NOTICE

import UIKit
import Foundation

public protocol CICLayoutPropertyProtocol {
    associatedtype type
    var base: type {get}

    static var screenScale: CGFloat { get }
    static var screenWidth: CGFloat { get }
    static var screenHeight: CGFloat { get }
    static var screenSize: CGSize { get }

    // eg: 50.makeSize  == CGSize.init(width: 50, height: 50)
    var makeSize: CGSize { get }

    // eg: 50.makeRect == CGRect.init(origin: .zero, size: CGSize.init(width: 50, height: 50))
    var makeRect: CGRect { get }

    // eg 20.makeEdgeInsets = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
    var makeEdgeInsets: UIEdgeInsets { get }
}

extension CICLayoutPropertyProtocol {
    public static var screenScale: CGFloat { return UIScreen.main.scale }

    public static var screenSize: CGSize { return UIScreen.main.bounds.size }

    public static var screenHeight: CGFloat { return UIScreen.main.bounds.height }

    public static var screenWidth: CGFloat { return UIScreen.main.bounds.width }

    public var makeSize: CGSize {
        if let base = base as? CGFloat {
            return CGSize.init(width: base, height: base)
        } else if let base = base as? Double {
            return CGSize.init(width: base, height: base)
        } else if let base = base as? Int {
            return CGSize.init(width: base, height: base)
        }
        return .zero
    }
    public var makeRect: CGRect {
        return CGRect.init(origin: .zero, size: self.makeSize)
    }

    public var makeEdgeInsets: UIEdgeInsets {
        if let base = base as? CGFloat {
            return UIEdgeInsets.init(top: base, left: base, bottom: base, right: base)
        }
        return UIEdgeInsets.zero
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

extension UIEdgeInsets {
    public static var layoutMargins: UIEdgeInsets {
        return UIWindow().layoutMargins
    }
}
