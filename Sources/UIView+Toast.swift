//
//  UIView+Toast.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

extension UIView {
    var internalCenter: CGPoint {
        return CGPoint.init(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5)
    }
}


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
    
    public enum CILoadingStyle {
        case original
        case style1
        case style2
        case style3
        case style4
        case style5
    }
    
    // CILoadingStyle.original  原生的加载指示器
    lazy var activityView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activity.color = CILoadingHUD.appearance().tintColor
        return activity
    }()
    
    var loadingStyle: CILoadingStyle = .original
    
    public enum CILoadingLayoutStyle {
        case left // title is left
        case top
        case right
        case bottom
    }
    var layoutStyle: CILoadingLayoutStyle = .top

    // tip's title  提示文字
    var title: String? = "加载中~"
    
    var attributeTitle: NSMutableString? = NSMutableString(string: "")

    
    //MARK: - init && deinit
    public static let `default` = CILoadingHUD.init("加载中", blurStyle: .light, layoutStyle: .top)
    
    public init(_ title: String?, blurStyle: UIBlurEffectStyle = .extraLight,layoutStyle: CILoadingLayoutStyle = .left) {
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
        
        activityView.startAnimating()
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
    
    
    public override func tintColorDidChange() {
        titleLabel.textColor = self.tintColor
        activityView.color = self.tintColor
    }
    
    func resizeLayout() -> Swift.Void {
    
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame = self.bounds
        
        animationImgView.frame.size = CGSize.init(width: 64, height: 64)
        
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        switch layoutStyle {
        case .top:
            animationImgView.center.x = backgroundView.bounds.width * 0.5
            animationImgView.frame.origin.y = 20
            if loadingStyle == .original {
                activityView.center = animationImgView.internalCenter
            }
            
            titleLabel.center.x = backgroundView.center.x
            titleLabel.frame.origin.y = animationImgView.frame.maxY + 30
            break
        case .right:
            break
        case .bottom:
            break
            
        default:
            
            break
        }
        
    }
    
    /// 计算Loading布局 calculate loading hud's layout
    ///
    /// - Returns: Void
    func layout() -> Swift.Void {
        
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
    
    public func show(_ title: String?, blurStyle: UIBlurEffectStyle = .dark,layoutStyle: CILoadingLayoutStyle = .left,delay: TimeInterval? = 0.0) {
        let hud = CILoadingHUD.init(title, blurStyle: blurStyle, layoutStyle: layoutStyle)
        hud.layout()
    }
    
    public class func show(_ title: String?, blurStyle: UIBlurEffectStyle = .dark,layoutStyle: CILoadingLayoutStyle = .left,delay: TimeInterval? = 0.0) {
        CILoadingHUD.default.title = title
        CILoadingHUD.default.blurStyle = blurStyle
        CILoadingHUD.default.layoutStyle = layoutStyle
        CILoadingHUD.default.layout()
    }
    
    public func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        self.removeFromSuperview()
        print("remove .......")
    }
    
    public class func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        CILoadingHUD.default.hide(complete)
    }
}
