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
        CILoadingHUD.show(title)
    }
}

public typealias CILoadingHUDClousure =  ((Bool) -> Swift.Void)

///MARK: - CILoadingHUD
public class CILoadingHUD: UIView {

    //MARK: Property
    
    // default blurEffect = .extraLight 默认模糊效果
    var blurStyle: UIBlurEffectStyle = .extraLight
    
    // loading's style
    public enum CILoadingStyle {
        case original   // 系统自带的 UIActivityIndicatorView 指示器
        case style1
        case style2
        case style3
        case style4
        case style5
    }
    
    var loadingStyle: CILoadingStyle = .original
    
    public enum CILoadingLayoutStyle {
        case left // title is left
        case top
        case right
        case bottom
    }
    var layoutStyle: CILoadingLayoutStyle = .top

    
    // loading弹出时的动画
    public enum CILoadingAnimation {
        case none
        case spring
        case curveEaseInOut
    }
    var showAnimation:CILoadingAnimation = .none
    var hideAnimation:CILoadingAnimation = .none
    
    // tip's title  提示文字
    var title: String? = "加载中~"
    
    // tip's infomation
    var attributeTitle: NSMutableString? = NSMutableString(string: "")

    
    //MARK: - init && deinit
    public static let `default` = CILoadingHUD.init("加载中", blurStyle: .light, layoutStyle: .top)
    
    public init(_ title: String?,
                blurStyle: UIBlurEffectStyle = .extraLight,
                layoutStyle: CILoadingLayoutStyle = .left,
                loadingStyle: CILoadingStyle? = .original,
                showAnimation: CILoadingAnimation? = .none,
                hideAnimation: CILoadingAnimation? = .none) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        self.title = title
        self.layoutStyle = layoutStyle
        self.blurStyle = blurStyle
        
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        self.addSubview(backgroundView)
        
        let contentView = backgroundView.contentView
        
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        titleLabel.tintColor = CILoadingHUD.appearance().tintColor
        contentView.addSubview(titleLabel)
        
        animationImgView.contentMode = .center
        animationImgView.addSubview(activityView)
        contentView.addSubview(animationImgView)
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
        activity.color = CILoadingHUD.appearance().tintColor
        return activity
    }()
    
    
    
    func resizeLayout() -> Swift.Void {
    
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame = self.bounds
        
        animationImgView.frame.size = CGSize.init(width: 64, height: 64)
        
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        switch layoutStyle {
        case .top:
            animationImgView.y(20)
                .centerX(backgroundView.ci.internalCenterX)
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
                .centerY(backgroundView.ci.internalCenterY)
            titleLabel.x(animationImgView.frame.maxX+20)
                .centerY(backgroundView.ci.internalCenterY)
            break
        }
        
        if loadingStyle == .original {
            activityView.center = animationImgView.ci.internalCenter
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
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        // default layout
        self.frame = CGRect.init(origin: .zero, size: CGSize.init(width: keyWindow.bounds.width - 80, height: 160))
        self.center = keyWindow.center
        keyWindow.addSubview(self)
    
        resizeLayout()
    }
    
    //MARK: - show && hide
    
    public func show(_ title: String?,
                     blurStyle: UIBlurEffectStyle = .dark,
                     layoutStyle: CILoadingLayoutStyle = .left,
                     delay: TimeInterval? = 0.0) {
        let hud = CILoadingHUD.init(title, blurStyle: blurStyle, layoutStyle: layoutStyle)
        hud.render()
    }
    
    public class func show(_ title: String?,
                           blurStyle: UIBlurEffectStyle = .dark,
                           layoutStyle: CILoadingLayoutStyle = .left,
                           delay: TimeInterval? = 0.0) {
        CILoadingHUD.default.title = title
        CILoadingHUD.default.blurStyle = blurStyle
        CILoadingHUD.default.layoutStyle = layoutStyle
        CILoadingHUD.default.render()
    }
    
    public func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        self.removeFromSuperview()
    }
    
    public class func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        CILoadingHUD.default.hide(complete)
    }
}

