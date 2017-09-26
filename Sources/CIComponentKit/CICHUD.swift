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
var CICHUDRect = {CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.width - 80, height: 160))}()


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

    
    //MARK: - init && deinit
    public static let `default` = CICHUD.init("加载中", blurStyle: .light, layoutStyle: .top)
    
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
        self.addSubview(backgroundView)
        
        let contentView = backgroundView.contentView
        
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        titleLabel.tintColor = CICHUD.appearance().tintColor
        contentView.addSubview(titleLabel)
        
        animationImgView.contentMode = .center
        animationImgView.addSubview(activityView)
        contentView.addSubview(animationImgView)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(renderAfterUIDeviceOrientationDidChange(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - build ui
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
        if style == .loading {
            self.frame = CICHUDRect
        }else {
            self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 180, height: 100)
        }
        
        UIView.animate(withDuration: 0.35) { [unowned self] in
            if let superView = self.superview {
                self.center(superView.cic.internalCenter)
            }
        }
    }
    
    
    func resizeLayout() -> Swift.Void {
    
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame(self.bounds)
        
        animationImgView.size(CGSize.init(width: 64, height: 64))
        
        activityView.isHidden = (style == .toast)
        
        titleLabel.text(title).textAlignment(.center).sizeTo(layout: .width(100))
        
        switch layoutStyle {
        case .top:
            animationImgView.y(20)
                .centerX(backgroundView.cic.internalCenterX)
            titleLabel.y(animationImgView.frame.maxY + 30)
                .centerX(backgroundView.center.x)
            break
        case .right:
            titleLabel.x(20)
            animationImgView.y()
            break
        case .bottom:
            break
            
        default:
            animationImgView.x(20)
                .centerY(backgroundView.cic.internalCenterY)
            titleLabel.x(animationImgView.frame.maxX+20)
                .centerY(backgroundView.cic.internalCenterY)
            break
        }
        if style == .toast && animationImgView.image == nil {
            animationImgView.isHidden = true
            titleLabel.center(self.cic.internalCenter)
        }else {
            animationImgView.isHidden = false
        }
        if loadingStyle == .original {
            activityView.center = animationImgView.cic.internalCenter
            activityView.startAnimating()
            if blurStyle == .dark {
                activityView.color = UIColor.white
                titleLabel.textColor(UIColor.white)
            }
        }
        
        
    }
    
    /// 计算Loading布局 calculate loading hud's layout
    ///
    /// - Returns: Void
    func render() -> Swift.Void {
        
        resizeLayout()
    }
    
    //MARK: - show && hide
    
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
        CICHUD.default.title = title
        CICHUD.default.blurStyle = blurStyle
        CICHUD.default.layoutStyle = layoutStyle
        CICHUD.default.frame(CICHUDRect)
        if let keyWindow = UIApplication.shared.keyWindow {
            // default layout
            CICHUD.default.center(keyWindow.center)
            keyWindow.addSubview(CICHUD.default)
        }
        CICHUD.default.render()
    }
    
    public class func toast(_ title: String?,
                            blurStyle: UIBlurEffectStyle = .dark,
                            layoutStyle: CICHUDLayoutStyle = .left,
                            delay: TimeInterval? = 0.0, duration: TimeInterval = 1.25) {
        
        CICHUD.default.style = .toast
        CICHUD.default.title = title
        CICHUD.default.blurStyle = blurStyle
        CICHUD.default.layoutStyle = layoutStyle
        CICHUD.default.frame(CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 180, height: 100))
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            // default layout
            CICHUD.default.center(keyWindow.center)
            keyWindow.addSubview(CICHUD.default)
        }
        
        CICHUD.default.render()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { 
            CICHUD.hide()
        }
    }

    
    public func hide(_ complete: CICHUDClousure = {_ in }) {
        self.removeFromSuperview()
    }
    
    public class func hide(_ complete: CICHUDClousure = {_ in }) {
        CICHUD.default.hide(complete)
    }
}

