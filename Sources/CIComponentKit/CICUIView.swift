//
//  UIView+Layout.swift
//  CIComponentKit
//
//  Created by ManoBoo on 11/09/2017.
//  Copyright © 2017 CodeInventor. All rights reserved.
//  UIView一些常用的便捷布局

import UIKit

public class CICUIView: UIView, CICAppearance {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initMethod()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // CICAppearance  主题支持
    func initMethod() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.willToggleTheme),
                                               name: Notification.Name.cic.themeWillToggle,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.didToggleTheme),
                                               name: Notification.Name.cic.themeDidToggle,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.deviceOrientationDidChange),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    // MARK: - CICAppearance Protocol

    public func willToggleTheme() {

    }

    public func didToggleTheme() {
        self.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
    }

    public func deviceOrientationDidChange() {

    }
}
