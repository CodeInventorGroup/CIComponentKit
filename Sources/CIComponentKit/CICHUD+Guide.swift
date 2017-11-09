//
//  CICHUD+Guide.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/12.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  页面中弹出一个类似于UIAlertView或者UIAlertController的东西, 建议打开蒙板

import UIKit


extension CICHUD {
    
    public class GuideView: UIView {
        
        /// 展示内容内部边距
        public var contentInsets = UIEdgeInsets.init(top: 22, left: 20, bottom: 20, right: 20)
        
        /// 展示内容外部边距,top无效
        public var contentMargins = UIEdgeInsets.layoutMargins
        
        public var title = "提示"
        public let titleLabel = UILabel()
        
        public var message: String?
        public let messageLabel = UILabel()
        
        /// 是否需要黑色蒙板
        public var isDisplayBlackMask = false {
            didSet {
                backgroungView.alpha = isDisplayBlackMask ? 0.6 : 0
            }
        }
        
        /// contentView
        public var contentView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
        
        /// 黑色遮罩
        public var backgroungView = UIView()
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            initSubviews()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func initSubviews() {
            backgroungView.backgroundColor(UIColor.black)
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hide))
            backgroungView.addGestureRecognizer(tapGesture)
            self.addSubview(backgroungView)
            
            contentView.layer.cornerRadius = 6.0
            contentView.layer.masksToBounds = true
            self.addSubview(contentView)
            titleLabel.textColor(CIComponentKitThemeCurrentConfig.tintColor).line(0)
            contentView.contentView.addSubview(titleLabel)
            messageLabel.textColor(CIComponentKitThemeCurrentConfig.alertMessageColor).line(0)
            contentView.contentView.addSubview(messageLabel)
        }
        
        func render() {
            backgroungView.frame(self.bounds)
            // calculate size of content
            contentView.x(contentMargins.left).backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
                .width(self.cic.width - contentMargins.left - contentMargins.right)
            
            titleLabel.text(title)
                .font(UIFont.cic.preferred(.headline))
                .textColor(CIComponentKitThemeCurrentConfig.tintColor)
                .x(contentInsets.left)
                .y(contentInsets.top)
                .width(contentView.cic.width - contentInsets.left - contentInsets.right)
                .sizeTo(layout: .width(titleLabel.cic.width))
            messageLabel.text(message)
                .font(UIFont.cic.preferred(.body))
                .textColor(CIComponentKitThemeCurrentConfig.alertMessageColor)
                .x(titleLabel.cic.x)
                .y(titleLabel.frame.maxY + 15)
                .width(titleLabel.cic.width)
                .height(UIFont.systemFontSize)
                .sizeTo(layout: .width(titleLabel.cic.width))
            
            contentView.height(messageLabel.frame.maxY + contentInsets.bottom)
                .y(self.cic.height - contentView.cic.height - contentMargins.bottom)
        }
        
        @objc func hide() {
            self.removeFromSuperview()
        }
    }
    
    public class func showGuide(_ title: String = "提示", message: String? = nil, animated: Bool = true) {
        let guide = GuideView()
        guide.title = title
        guide.message = message
        
        if let keyWindow = UIApplication.shared.keyWindow {
            guide.frame(keyWindow.bounds)
            guide.render()
            
            if !animated {
                keyWindow.addSubview(guide)
            }else {
                keyWindow.addSubview(guide)
                guide.backgroungView.alpha = 0
                UIView.animate(withDuration: 0.35, animations: {
                    guide.backgroungView.alpha = 0.6
                })
                let destinationY = guide.contentView.cic.y
                guide.contentView.y(guide.cic.height)
                UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                    guide.contentView.y(destinationY)
                }, completion: { (_) in
                    
                })
            }
        }
    }
}
