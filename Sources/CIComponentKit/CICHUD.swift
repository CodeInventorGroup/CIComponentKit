//
//  UIView+Toast.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

public extension CIComponentKit where Base: UIView {

    func allInfomation() -> Swift.Void {
        print(self.base)
    }

    func showLoading(_ title: String?) -> Swift.Void {
        CICHUD.show(title)
    }
}

public typealias CICHUDClousure =  ((Bool) -> Swift.Void)

/// MARK: - CICHUD
public class CICHUD: CICUIView {

    /// - DdefaultConfig

    static var CICHUDLoadingRect = CGRect.init(origin: .zero,
                                               size: CGSize(width: CGFloat.screenWidth - 100, height: 120))

    static var CICHUDToastRect = CGRect.init(origin: .zero,
                                             size: CGSize(width: CGFloat.screenWidth * 0.8, height: 60))

    // 内部边距
    var CICHUDInsets = 20.makeEdgeInsets
    
    // MARK: Property
    public enum Style {
        case loading
        case toast
    }

    var style: Style = .loading

    // default blurEffect = .extraLight 默认模糊效果
    var blurStyle: UIBlurEffectStyle = .extraLight

    // loading's style
    public enum CICHUDLoadingStyle {
        case original   // 系统自带的 UIActivityIndicatorView 指示器
        case style1
        case style2
        case style3
        case style4
        case style5
    }

    var loadingStyle: CICHUDLoadingStyle = .original

    public enum CICHUDLayoutStyle {
        case left // title is left
        case top
        case right
        case bottom
    }
    var layoutStyle: CICHUDLayoutStyle = .top

    // loading弹出时的动画
    public enum CICHUDAnimation {
        case none
        case spring
        case curveEaseInOut
    }
    var showAnimation:CICHUDAnimation = .none
    var hideAnimation:CICHUDAnimation = .none

    // tip's title  提示文字
    var title: String? = "加载中~"

    // tip's infomation
    var attributeTitle: NSMutableString? = NSMutableString(string: "")

    // MARK: - init && deinit
    public static let `default` = CICHUD.init("加载中", blurStyle: .light, layoutStyle: .left)

    public init(_ title: String?,
                style: CICHUD.Style = .loading,
                blurStyle: UIBlurEffectStyle = .extraLight,
                layoutStyle: CICHUDLayoutStyle = .left,
                loadingStyle: CICHUDLoadingStyle = .original,
                showAnimation: CICHUDAnimation = .none,
                hideAnimation: CICHUDAnimation = .none) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        self.title = title
        self.style = style
        self.blurStyle = blurStyle
        self.layoutStyle = layoutStyle
        self.loadingStyle = loadingStyle
        self.showAnimation = showAnimation
        self.hideAnimation = hideAnimation
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)

        let contentView = backgroundView.contentView

        titleLabel.font = UIFont.cic.systemFont
        titleLabel.tintColor = CICHUD.appearance().tintColor
        contentView.addSubview(titleLabel)

        animationImgView.contentMode = .center
        animationImgView.addSubview(activityView)

        contentView.addSubview(animationImgView)
    }

    deinit {
        print("CICHUD deinit")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - build ui
    var backgroundView = UIVisualEffectView()
    var titleLabel = UILabel().line(0)
    var animationImgView = UIImageView()
    // CILoadingStyle.original  原生的加载指示器
    lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activity.color = CICHUD.appearance().tintColor
        return activity
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        resizeLayout()
    }

    func resizeLayout() {
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame(self.bounds)

        animationImgView.size(CGSize(width: 64, height: 64))
        activityView.isHidden = (style == .toast)

        titleLabel.text(title).textAlignment(.center).sizeToFit()
        if style == .toast {
            animationImgView.isHidden = true
            titleLabel.width(backgroundView.cic.width * 0.8).sizeToFit()
            titleLabel.centerX(backgroundView.cic.internalCenterX)
                .centerY(backgroundView.cic.internalCenterY)
        } else {
            animationImgView.isHidden = false
            activityView.centerX(animationImgView.cic.internalCenterX)
                .centerY(animationImgView.cic.internalCenterY)

            switch layoutStyle {
            case .top:
                    animationImgView.y(CICHUDInsets.top).centerX(self.cic.internalCenterX)
                    titleLabel.y(animationImgView.frame.maxY + 30)
                        .centerX(self.cic.internalCenterX)
            case .right:
                    titleLabel.x(backgroundView.cic.x + CICHUDInsets.left)
                        .centerY(self.cic.internalCenterY)
                    animationImgView.x(titleLabel.frame.maxX + 20)
                        .centerY(self.cic.internalCenterY)
            case .bottom:
                    titleLabel.y(CICHUDInsets.top)
                        .centerX(backgroundView.cic.internalCenterX)
                    animationImgView.y(titleLabel.frame.maxY + 30)
                        .centerX(backgroundView.cic.internalCenterX)
            default:
                    animationImgView.x(CICHUDInsets.left)
                        .centerY(backgroundView.cic.internalCenterY)
                    titleLabel.x(animationImgView.frame.maxX + 20)
                        .centerY(backgroundView.cic.internalCenterY)
            }

            if loadingStyle == .original {
                activityView.startAnimating()
                if blurStyle == .dark {
                    // 防止文字与背景颜色相近
                    activityView.color = UIColor.white
                    titleLabel.textColor(UIColor.white)
                }
            }
        }
    }

    // MARK: - CICAppearance
    public override func deviceOrientationDidChange() {
        super.deviceOrientationDidChange()
        guard let superview = self.superview else {
            return
        }

        self.frame( style == .loading ? CICHUD.CICHUDLoadingRect: CICHUD.CICHUDToastRect)
            .center(superview)
    }

    // MARK: - Pulic Method

    public class func show(_ title: String?,
                           blurStyle: UIBlurEffectStyle = .dark,
                           layoutStyle: CICHUDLayoutStyle = .left,
                           delay: TimeInterval? = 0.0) {
        CICHUD.default.removeFromSuperview()
        CICHUD.default.style = .loading
        CICHUD.default.title = title
        CICHUD.default.blurStyle = blurStyle
        CICHUD.default.layoutStyle = layoutStyle
        if let keyWindow = UIApplication.shared.keyWindow {
            CICHUD.default.frame(CICHUDLoadingRect)
            keyWindow.addSubview(CICHUD.default)
            keyWindow.bringSubview(toFront: CICHUD.default)
            CICHUD.default.center(keyWindow.cic.internalCenter)
        }
    }

    public class func toast(_ title: String?,
                            blurStyle: UIBlurEffectStyle = .dark,
                            delay: TimeInterval? = 0.0,
                            duration: TimeInterval = 1.25) {
        let hud = CICHUD.init("", blurStyle: .light, layoutStyle: .left)
        hud.style = .toast
        hud.title = title
        hud.blurStyle = blurStyle

        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(hud)
            keyWindow.bringSubview(toFront: hud)
            if let title = title {
                let hudWidth = CGFloat.minimum(title.cicWidth(.greatestFiniteMagnitude, font: UIFont.cic.systemFont) * 1.2,
                                               CICHUDToastRect.width)
                let hudHeight = CGFloat.maximum(title.cicHeight(hudWidth, font: UIFont.cic.systemFont),
                                                CICHUDToastRect.height)
                hud.width(hudWidth).height(hudHeight).center(keyWindow.cic.internalCenter)
            } else {
                hud.frame(CICHUDToastRect)
                    .center(keyWindow.cic.internalCenter)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            hud.hide()
        }
    }

    public func hide(_ complete: CICHUDClousure = {_ in }) {
        self.removeFromSuperview()
    }

    public class func hide(_ complete: CICHUDClousure = {_ in }) {
        CICHUD.default.hide(complete)
    }
}
