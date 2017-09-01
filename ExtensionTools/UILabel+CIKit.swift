//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/31.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit


/********************************************* this is a demo ******************************
 
 let label = UILabel().ci.appearance
 label.text = "welcome to cicomponentkti~ O(∩_∩)O~~"
 self.view.addSubview(label)
 
 ********************************************* this is a demo ******************************/



// 为调用了 ci.appearance 方法的UILabel实例 添加 CIComponentAppearance 协议支持
extension UILabel: CIComponentAppearance {
    
    func didToggleTheme() {
        if self.textColor != CIComponentKitTheme.currentTheme.config.textColor {
            self.textColor = CIComponentKitTheme.currentTheme.config.textColor
        }
        if self.font == CIComponentKitTheme.currentTheme.config.defaultFont {
            self.font = UIFont.systemFont(ofSize: UIFont.systemFontSize + 2.0)
        }else {
            self.font = UIFont.ci.systemFont
        }
        
        //        print("\(self) didToggleTheme")
    }
    
    func willToggleTheme() {
        //        print("\(self) willToggleTheme")
    }
}
