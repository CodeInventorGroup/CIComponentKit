//
//  CICHUD+Network.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/30.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  网络情况的HUD, 比如 正在连接 etc.

import UIKit

public var CICHUD_NetWorkStatusDefaultTip = "您已失去网络连接"
public var CICHUD_NetWorkStatusDefaultOffset: CGFloat = 64
public var CICHUD_NetWorkStatusAnimationDurationInterval = 0.75

extension CICHUD {
    public class NetWorkStatusView: UIView {
        
        static let `default` = NetWorkStatusView.init(frame: .zero)
        
        public var statusTitle: String = CICHUD_NetWorkStatusDefaultTip {
            didSet {
                statusLabel.text(statusTitle).sizeTo(layout: UIView.CICLayoutType.maxWidth(CGFloat.screenWidth - 80))
            }
        }
        
        public var image: UIImage? = nil {
            didSet {
                if image == nil {
                    activityView.size(imageView.bounds.size)
                    activityView.startAnimating()
                }else {
                    activityView.stopAnimating()
                    imageView.image = image
                }
            }
        }
        
        let imageView = UIImageView()
        let statusLabel = UILabel()
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView()
        
        public override init(frame: CGRect) {
            super.init(frame: .zero)
            self.backgroundColor = CIComponentKitThemeCurrentConfig.mainColor
            self.clipsToBounds = true
            self.addSubview(imageView)
            self.addSubview(statusLabel)
            
            imageView.image = image
            imageView.x(24)
                .size(CGSize.init(width: 20, height: 20))
                .centerY(12)
            
            imageView.addSubview(activityView)
            
            statusLabel.text(statusTitle)
                .font(UIFont.cic.systemFont)
                .textColor(CIComponentKitThemeCurrentConfig.textColor)
            statusLabel.line()
                .x(imageView.frame.maxX + 15)
                .height(20)
                .centerY(12)
        }
        
        func render() {
            self.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
            statusLabel.textColor(CIComponentKitThemeCurrentConfig.tintColor)
            activityView.color = CIComponentKitThemeCurrentConfig.tintColor
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension CICHUD {
    public class func showNetWorkStatusChange(_ title: String = CICHUD_NetWorkStatusDefaultTip, _ image: UIImage? = nil) {
        NetWorkStatusView.default.removeFromSuperview()
        NetWorkStatusView.default.statusTitle = title
        NetWorkStatusView.default.image = image
        NetWorkStatusView.default.render()
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(NetWorkStatusView.default)
            NetWorkStatusView.default.y(CICHUD_NetWorkStatusDefaultOffset).width(CGFloat.screenWidth).height(0)
            UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
                NetWorkStatusView.default.height(24)
            }, completion: {finished in
            })
        }
    }
    
    public class func hideNetWorkStatusChange() {
        UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
            NetWorkStatusView.default.height(0)
        }) { (finished) in
            if finished {
                NetWorkStatusView.default.removeFromSuperview()
            }
        }
    }
}

