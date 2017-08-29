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
        CILoaingHUD.show(title)
    }
}

public typealias CILoadingHUDClousure =  ((Bool) -> Swift.Void)

///MARK: - CILoadingHUD
public class CILoaingHUD: UIView {

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
    public static let `default` = CILoaingHUD.init("加载中", blurStyle: .light, layoutStyle: .top)
    
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
        titleLabel.textColor = CILoaingHUD.appearance().tintColor
        contentView.addSubview(titleLabel)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - build ui
    var backgroundView = UIVisualEffectView()
    var titleLabel = UILabel()
    var animationImgView = UIImageView()
    
    func resizeLayout() -> Swift.Void {
    
        backgroundView.effect = UIBlurEffect.init(style: blurStyle)
        backgroundView.frame = self.bounds
        
        animationImgView.frame.size = CGSize.init(width: 64, height: 64)
        
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        switch layoutStyle {
        case .top:
            animationImgView.center.x = 0.5
            animationImgView.frame.origin.y = 20
            
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
        self.frame = CGRect.init(origin: .zero, size: CGSize.init(width: keyWindow.bounds.width - 80, height: 200))
        self.center = keyWindow.center
        keyWindow.addSubview(self)
        
        resizeLayout()
    }
    
    //MARK: - show && hide
    
    public func show(_ title: String?, blurStyle: UIBlurEffectStyle = .dark,layoutStyle: CILoadingLayoutStyle = .left,delay: TimeInterval? = 0.0) {
        let hud = CILoaingHUD.init(title, blurStyle: blurStyle, layoutStyle: layoutStyle)
        hud.layout()
    }
    
    public class func show(_ title: String?, blurStyle: UIBlurEffectStyle = .dark,layoutStyle: CILoadingLayoutStyle = .left,delay: TimeInterval? = 0.0) {
        CILoaingHUD.default.title = title
        CILoaingHUD.default.blurStyle = blurStyle
        CILoaingHUD.default.layoutStyle = layoutStyle
        CILoaingHUD.default.layout()
    }
    
    public func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        self.removeFromSuperview()
        print("remove .......")
    }
    
    public class func hide(_ complete: CILoadingHUDClousure = {_ in }) {
        CILoaingHUD.default.hide(complete)
    }
}
