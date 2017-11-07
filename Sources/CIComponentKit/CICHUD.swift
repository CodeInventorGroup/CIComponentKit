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

/// - DdefaultConfig
var CICHUDLoadingRect = {CGRect.init(origin: .zero, size: CGSize.init(width: CGFloat.screenWidth - 100, height: 120))}()
var CICHUDToastRect = {CGRect.init(origin: .zero, size: CGSize.init(width: CGFloat.screenWidth - 180, height: 60))}()
var CICHUDInsets = UIEdgeInsetsMake(20, 20, 20, 20)
var CICHUDAutoResize = false   // 是否自适应大小

public typealias CICHUDClousure =  ((Bool) -> Swift.Void)

///MARK: - CICHUD
public class CICHUD: UIView {

    //MARK: Property
    
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
        
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
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
    var titleLabel = UILabel()
    var animationImgView = UIImageView()
    // CILoadingStyle.original  原生的加载指示器
    lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activity.color = CICHUD.appearance().tintColor
        return activity
    }()

    func renderAfterUIDeviceOrientationDidChange(notification: Notification) -> Swift.Void {
        
        UIView.animate(withDuration: 0.35) { [unowned self] in
            if let superView = self.superview {
                self.center(superView.cic.internalCenter)
            }
        }
    }

    func resizeLayout() -> Swift.Void {
//        let marginsGuide = self.layoutMarginsGuide
        
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame(self.bounds)
        
        animationImgView.size(CGSize(width: 64, height: 64))
        activityView.isHidden = (style == .toast)
        
        titleLabel.text(title).textAlignment(.center).sizeToFit()
        if style == .toast {
            animationImgView.isHidden = true
            titleLabel.centerX(backgroundView.cic.internalCenterX)
                .centerY(backgroundView.cic.internalCenterY)
        }else {
            animationImgView.isHidden = false
            activityView.centerX(animationImgView.cic.internalCenterX)
                .centerY(animationImgView.cic.internalCenterY)

            switch layoutStyle {
                case .top:
                    animationImgView.y(CICHUDInsets.top).centerX(self.cic.internalCenterX)
                    titleLabel.y(animationImgView.frame.maxY + 30)
                        .centerX(self.cic.internalCenterX)
                    break
                case .right:
                    titleLabel.x(backgroundView.cic.x + CICHUDInsets.left)
                        .centerY(self.cic.internalCenterY)
                    animationImgView.x(titleLabel.frame.maxX + 20)
                        .centerY(self.cic.internalCenterY)
                    break
                case .bottom:
                    titleLabel.y(CICHUDInsets.top)
                        .centerX(backgroundView.cic.internalCenterX)
                    animationImgView.y(titleLabel.frame.maxY + 30)
                        .centerX(backgroundView.cic.internalCenterX)
                    break
                default:
                    animationImgView.x(CICHUDInsets.left)
                        .centerY(backgroundView.cic.internalCenterY)
                    titleLabel.x(animationImgView.frame.maxX + 20)
                        .centerY(backgroundView.cic.internalCenterY)
                    break
            }

            if CICHUDAutoResize {
                self.width((animationImgView.frame.maxX < titleLabel.frame.maxX ? animationImgView.cic.width : titleLabel.cic.width) + 2 * CICHUDInsets.right)
                self.height((animationImgView.frame.maxY < titleLabel.frame.maxY ? animationImgView.cic.height : titleLabel.cic.height) + 2 * CICHUDInsets.bottom)
                backgroundView.frame(self.bounds)
                if layoutStyle == .top || layoutStyle == .bottom {
                    titleLabel.centerX(backgroundView.cic.internalCenterX)
                    animationImgView.centerX(backgroundView.cic.internalCenterX)
                }else {
                    titleLabel.centerY(backgroundView.cic.internalCenterY)
                    animationImgView.centerY(backgroundView.cic.internalCenterY)
                }
            }
            
            if loadingStyle == .original {
                activityView.startAnimating()
                if blurStyle == .dark {
                    activityView.color = UIColor.white
                    titleLabel.textColor(UIColor.white)
                }
            }
        }
    }
    
    /// 计算Loading布局 calculate loading hud's layout
    ///
    /// - Returns: Void
    func render() -> Swift.Void {
        if let _ = self.superview {
            resizeLayout()
        }
    }
    
    // MARK: - show && hide
    public func show(_ title: String?,
                     blurStyle: UIBlurEffectStyle = .dark,
                     layoutStyle: CICHUDLayoutStyle = .left,
                     delay: TimeInterval? = 0.0) {
        let hud = CICHUD.init(title, blurStyle: blurStyle, layoutStyle: layoutStyle)
        hud.render()
    }
    
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
            CICHUD.default.render()
            CICHUD.default.center(keyWindow.cic.internalCenter)
        }
        
    }
    
    public class func toast(_ title: String?,
                            blurStyle: UIBlurEffectStyle = .dark,
                            delay: TimeInterval? = 0.0, duration: TimeInterval = 1.25) {
        
        let hud = CICHUD.init("", blurStyle: .light, layoutStyle: .left)
        hud.style = .toast
        hud.title = title
        hud.blurStyle = blurStyle
        
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(hud)
            keyWindow.bringSubview(toFront: hud)
            hud.frame(CICHUDToastRect).center(keyWindow.cic.internalCenter)
            hud.render()
            hud.center(keyWindow.cic.internalCenter)
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

