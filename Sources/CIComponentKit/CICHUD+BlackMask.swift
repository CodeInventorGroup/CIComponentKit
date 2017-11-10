//
//  CICHUD+BlackMask.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/11/10.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

class CICHUDBlackMask: CICUIView {
    var colorAlpha: CGFloat = 0.7

    override func initMethod() {
        super.initMethod()
        self.backgroundColor(UIColor.cic.hex(hex: 0x000000, alpha: colorAlpha))
    }

    override func deviceOrientationDidChange() {
        super.deviceOrientationDidChange()
        guard let superview = self.superview else {
            return
        }
        self.frame(superview.bounds)
    }
}
