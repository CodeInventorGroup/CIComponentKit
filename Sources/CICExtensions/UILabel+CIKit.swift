//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 15/09/2017.
//  Copyright © 2017 club.codeinventor. All rights reserved.
//  对UILabel做一些链式语法的扩展

import UIKit

/********************************************* extension UILabel begin ******************************/


extension UILabel {
    
    /// numberOfLines
    @discardableResult
    public func line(_ lineNumbers: Int = 1) -> Self {
        self.numberOfLines = lineNumbers
        return self
    }
    
    /// text
    @discardableResult
    public func text(_ string : String? = nil) -> Self {
        self.text = string
        return self
    }
    
    /// font
    @discardableResult
    public func font(_ font : UIFont = UIFont.cic.systemFont) -> Self {
        self.font = font
        return self
    }
    
    /// textColor
    @discardableResult
    public func textColor(_ color: UIColor = CIComponentKitThemeCurrentConfig.textColor) -> Self {
        self.textColor = color
        return self
    }
    
    /// textAlignment
    @discardableResult
    public func textAlignment(_ textAlignment: NSTextAlignment = .left) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
}

/********************************************* extension UILabel end ******************************/
