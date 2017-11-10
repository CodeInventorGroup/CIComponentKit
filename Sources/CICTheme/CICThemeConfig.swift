//
//  CICThemeConfig.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/1.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit
import Foundation

// 该属性可以获取当前主题的颜色配置
public var CIComponentKitThemeCurrentConfig = CIComponentKitTheme.currentTheme.config

// ThemeColorList    一份默认的主题配置
public class CIComponentKitThemeConfig {
    
    // theme's id
     public var identifier = "Default"

    // MARK: - colors -------------------------------------------------------------------------------------

        // theme's main color
         public var mainColor = UIColor.cic.hex(hex: 0xF7F6F6)

        // view.backgroundColor
         public var backgroundColor = UIColor.cic.rgb(red: 255, green: 255, blue: 255)

        // window's backgroundColor
         public var windowColor = UIColor.clear

        // UILabel | UIButton
         public var textColor = UIColor.black

        // alert | toast | loading | UITabbarButtonItem
         public var tintColor = UIColor.init(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0)

        // `UIActivityIndicator`.color
        public var activityIndicatorColor = UIColor.gray

        // alertView、alertViewController confirm button color
         public var confirmColor = UIColor.cic.hex(hex: 0x5CC9F5)
    
        // alertView、alertViewController cancel button color
         public var cancelColor = UIColor.cic.rgb(red: 175, green: 174, blue: 169)

        // UIAlertController - message 's color
         public var alertMessageColor = UIColor.cic.hex(hex: 0x7A7A7A)

         public var navigationBarBackgroundColor = UIColor.cic.rgb(red: 209, green: 211, blue: 138)
    
         public var navigationBarLeftColor = UIColor.cic.rgb(red: 209, green: 211, blue: 138)

         public var navigationBarRightColor = UIColor.init(red: 0, green: 0.478431, blue: 1.0, alpha: 1.0)

        // navigationItem的文字颜色
         public var navigationItemTitleColor = UIColor.black

        // 高亮背景颜色,比如长按复制时的UILabel背景颜色
         public var highlightedBackgroundColor = UIColor.cic.hex(hex: 0xF7F6F6, alpha: 0.8)

    // MARK: - fonts -------------------------------------------------------------------------------------
    
        // 默认字体大小， 这里和系统保持一致，一般产品中都使用的字体大小为14
         public var defaultFontSize = UIFont.systemFontSize
    
        // 默认字体
         public var defaultFont = UIFont.cic.systemFont
}
