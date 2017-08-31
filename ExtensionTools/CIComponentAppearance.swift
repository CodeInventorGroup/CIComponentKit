//
//  CIComponentAppearance.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

//class CIComponentAppearance<UIViewAppearance: UIAppearance> {
//    
//    class var appearance: UIViewAppearance {
//        get {
//            return UIViewAppearance.appearance()
//        }
//    }
//    
//    
//    class func switchThemeColor() -> Swift.Void {
//        
//    }
//}

@objc protocol CIComponentAppearance {
   
    func willToggleTheme() -> Swift.Void
    func didToggleTheme() -> Swift.Void
    
}
