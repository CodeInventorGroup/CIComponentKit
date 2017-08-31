//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/31.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

extension UILabel: CIComponentAppearance {
    
    func didToggleTheme() {
        print("\(self.self) didToggleTheme")
    }
    func willToggleTheme() {
        print("\(self.self) willToggleTheme")
    }
}


extension CIComponentKit where Base: UILabel {
    public var appearance: UILabel {
        return self.base
    }
}
