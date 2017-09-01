//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/31.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit


/********************************************* this is a demo ******************************
 
 let label = UILabel.ci.appearance
 label.text = "welcome to cicomponentkti~ O(∩_∩)O~~"
 self.view.addSubview(label)
 
 ********************************************* this is a demo ******************************/





//extension CIComponentKit where Base: UILabel {
//    
//    // 为了让用户的修改最少即可动态换主题，又减少操作，采取了折中方法
//    public var appearance: CILabel {
//        return CILabel()
//    }
//}

// 为了让用户用最少的修改即可动态换主题，又减少操作，采取了折中方法
public extension UILabel {
    struct ci {
        public static var appearance: CILabel {
            return CILabel()
        }
    }
}

// 为调用了 ci.appearance 方法的UILabel实例 添加 CIComponentAppearance 协议支持
extension CILabel: CIComponentAppearance {
    
    func didToggleTheme() {
        if self.textColor != CIComponentKitTheme.currentTheme.config.textColor {
            self.textColor = CIComponentKitTheme.currentTheme.config.textColor
        }
        if self.font != CIComponentKitTheme.currentTheme.config.defaultFont {
            self.font = CIComponentKitTheme.currentTheme.config.defaultFont
        }
        
        
    }
    
    func willToggleTheme() {
        
    }
}

public class CILabel: UILabel {
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initMethod()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initMethod() -> Swift.Void {
        // receive the notification of togglling theme
        NotificationCenter.default.addObserver(self, selector: #selector(CIComponentAppearance.willToggleTheme), name: Notification.Name.ci.themeWillToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CIComponentAppearance.didToggleTheme), name: Notification.Name.ci.themeDidToggle, object: nil)
    }
    
    deinit {
        print("\(CILabel.self) deinit")
        NotificationCenter.default.removeObserver(self)
    }
}
