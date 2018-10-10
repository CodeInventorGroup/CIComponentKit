//
//  UIFont+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/1.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

public extension UIFont {
    struct cic {
        
        // 系统自带的字体
        public static var systemFont: UIFont {
            return UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        
        public static func preferred(_ style: UIFont.TextStyle) -> UIFont {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
}
