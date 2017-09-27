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
        self.translatesAutoresizingMaskIntoConstraints = false
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.tintColor = CICHUD.appearance().tintColor
        contentView.addSubview(titleLabel)
        
        animationImgView.contentMode = .center
        animationImgView.translatesAutoresizingMaskIntoConstraints = false
        animationImgView.addSubview(activityView)
        
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: animationImgView.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: animationImgView.centerYAnchor).isActive = true
        
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
        let marginsGuide = self.layoutMarginsGuide
        
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.leftAnchor.constraint(equalTo: marginsGuide.leftAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: marginsGuide.topAnchor).isActive = true
        backgroundView.sizeAnchor(equalTo: marginsGuide)
    
        animationImgView.sizeAnchor(equalTo: CGSize(width: 64, height: 64))
        activityView.isHidden = (style == .toast)
        
        titleLabel.text(title).textAlignment(.center)
            .sizeTo(layout: .width(100))
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        
        let topConstraints = [animationImgView.topAnchor.constraint(equalTo: marginsGuide.topAnchor, constant: 20),
                             animationImgView.centerXAnchor.constraint(equalTo: marginsGuide.centerXAnchor),
                             titleLabel.topAnchor.constraint(equalTo: animationImgView.bottomAnchor, constant: 30),
                             titleLabel.centerXAnchor.constraint(equalTo: marginsGuide.centerXAnchor)]
        let rightConstraints = [titleLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20),
                               titleLabel.centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor),
                               animationImgView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 20),
                               animationImgView.centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor)]
        let leftConstraints = [animationImgView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 20),
                               animationImgView.centerYAnchor.constraint(equalTo: marginsGuide.centerYAnchor),
                               titleLabel.leftAnchor.constraint(equalTo: animationImgView.rightAnchor, constant: 20),
                               titleLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)]
        let bottomConstraints = [titleLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
                                 titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
                                 animationImgView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                                 animationImgView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)]
        
        switch layoutStyle {
            case .top:
                NSLayoutConstraint.deactivate(rightConstraints)
                NSLayoutConstraint.deactivate(bottomConstraints)
                NSLayoutConstraint.deactivate(leftConstraints)
                NSLayoutConstraint.activate(topConstraints)
//                _ = rightConstraints.map{$0.isActive = false}
//                _ = bottomConstraints.map{$0.isActive = false}
//                _ = leftConstraints.map{$0.isActive = false}
//                _ = topConstraints.map{$0.isActive = true}
                break
            case .right:
                NSLayoutConstraint.deactivate(topConstraints)
                NSLayoutConstraint.deactivate(leftConstraints)
                NSLayoutConstraint.deactivate(bottomConstraints)
                NSLayoutConstraint.activate(rightConstraints)
//                _ = topConstraints.map{$0.isActive = false}
//                _ = leftConstraints.map{$0.isActive = false}
//                _ = bottomConstraints.map{$0.isActive = false}
//                _ = rightConstraints.map{$0.isActive = true}
                break
            case .bottom:
                NSLayoutConstraint.deactivate(topConstraints)
                NSLayoutConstraint.deactivate(leftConstraints)
                NSLayoutConstraint.deactivate(rightConstraints)
                NSLayoutConstraint.activate(bottomConstraints)
//                _ = topConstraints.map{$0.isActive = false}
//                _ = leftConstraints.map{$0.isActive = false}
//                _ = rightConstraints.map{$0.isActive = false}
//                _ = bottomConstraints.map{$0.isActive = true}
                break
            default:
                NSLayoutConstraint.deactivate(rightConstraints)
                NSLayoutConstraint.deactivate(topConstraints)
                NSLayoutConstraint.deactivate(bottomConstraints)
                NSLayoutConstraint.activate(leftConstraints)
//                _ = rightConstraints.map{$0.isActive = false}
//                _ = topConstraints.map{$0.isActive = false}
//                _ = bottomConstraints.map{$0.isActive = false}
//                _ = leftConstraints.map{$0.isActive = true}
                break
        }
        self.setNeedsUpdateConstraints()
        
        if style == .toast && animationImgView.image == nil {
            animationImgView.isHidden = true
//            titleLabel.center(self.cic.internalCenter)
        }else {
            animationImgView.isHidden = false
        }
        if loadingStyle == .original {
//            activityView.center = animationImgView.cic.internalCenter
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
        if let superView = self.superview {
            self.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
            let toastConstraints = [self.widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -180),
                                    self.heightAnchor.constraint(equalToConstant: 100)]
            let loadingConstraints = [self.widthAnchor.constraint(equalTo: superView.widthAnchor, constant: -90),
                                      self.heightAnchor.constraint(equalToConstant: 200)]
            if style == .toast {
                NSLayoutConstraint.deactivate(loadingConstraints)
                NSLayoutConstraint.activate(toastConstraints)
            }else {
                NSLayoutConstraint.deactivate(toastConstraints)
                NSLayoutConstraint.activate(loadingConstraints)
            }
            resizeLayout()
        }
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
        CICHUD.default.removeFromSuperview()
        CICHUD.default.style = .loading
        CICHUD.default.title = title
        CICHUD.default.blurStyle = blurStyle
        CICHUD.default.layoutStyle = layoutStyle
        CICHUD.default.frame(CICHUDRect)
        if let keyWindow = UIApplication.shared.keyWindow {
            // default layout
            keyWindow.addSubview(CICHUD.default)
            keyWindow.bringSubview(toFront: CICHUD.default)
        }
        CICHUD.default.render()
    }
    
    public class func toast(_ title: String?,
                            blurStyle: UIBlurEffectStyle = .dark,
                            layoutStyle: CICHUDLayoutStyle = .left,
                            delay: TimeInterval? = 0.0, duration: TimeInterval = 1.25) {
        CICHUD.default.removeFromSuperview()
        CICHUD.default.style = .toast
        CICHUD.default.title = title
        CICHUD.default.blurStyle = blurStyle
        CICHUD.default.layoutStyle = layoutStyle
        
        if let keyWindow = UIApplication.shared.keyWindow {
            // default layout
            keyWindow.addSubview(CICHUD.default)
            keyWindow.bringSubview(toFront: CICHUD.default)
//            let toastConstraints = [CICHUD.default.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 90),
//                                    CICHUD.default.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -90),
//                                    CICHUD.default.heightAnchor.constraint(equalToConstant: 100),
//                                    CICHUD.default.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor)]
//            _ = toastConstraints.map{$0.isActive = true}
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

