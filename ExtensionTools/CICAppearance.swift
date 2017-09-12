//
//  CICAppearance.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit



//  this is a demo  , begin

/**********************************************
    class YourView: UIView {
        var titleLabel: UILabel
        var confirmButton: UIButton
        
        /* Your custom initialize method */
    }
    
    extension YourView: CIComponentAppearance {
        func willToggleTheme() {
 
        }
 
        func didToggleTheme() {
            // do what you want to do
            titleLabel.textColor = CIComponentKitTheme.currentTheme.textColor
        }
    }
    
    // How to  use ??
    let yourView = YourView().ci.appearce
 
 
 ************************************************/

// this is a demo  , end


// 如果想要自定义控件支持主题替换,请遵循CIComponentKitAppearance协议
/// custom component callback when current theme  (will toggle) / (toggled)
@objc protocol CICAppearance {

    
    /// 主题即将切换
    ///
    /// - Returns: s
    func willToggleTheme() -> Swift.Void
    
    
    /// 主题切换完毕
    ///
    /// - Returns: s
    func didToggleTheme() -> Swift.Void
    
}

