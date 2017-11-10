//
//  CICHUD+Network.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/30.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  网络情况的HUD, 比如 正在连接 etc.

import UIKit

extension CICHUD {
    public class NetWorkStatusView: CICUIView {
        
        static let `default` = NetWorkStatusView.init(frame: .zero)

        // MARK: - Config
        public static var defaultTip: String = "您已失去网络连接"
        public static var defaultOffset: CGFloat = CGFloat.maximum(UIEdgeInsets.layoutMargins.top, 20)
        public static var defaultAnimationDuration: TimeInterval = 0.75

        public var statusTitle: String = NetWorkStatusView.defaultTip {
            didSet {
                statusLabel.text(statusTitle)
                    .sizeTo(layout: .maxWidth(CGFloat.screenWidth - 4 * UIEdgeInsets.layoutMargins.left))
                    .centerY(12)
            }
        }

        public var image: UIImage? = nil {
            didSet {
                if image == nil {
                    activityView.size(imageView.bounds.size)
                    activityView.startAnimating()
                } else {
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
            self.clipsToBounds = true
            self.addSubview(imageView)
            self.addSubview(statusLabel)
            imageView.addSubview(activityView)
            render()
        }

        func render() {
            imageView.image = image
            imageView.x(24)
                .size(20.makeSize)
                .centerY(12)
            statusLabel.text(statusTitle)
                .font(UIFont.cic.systemFont)
                .textColor(CIComponentKitThemeCurrentConfig.textColor)
                .line()
                .x(imageView.frame.maxX + 15)
                .height(20)
            self.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
            activityView.color = CIComponentKitThemeCurrentConfig.tintColor
        }

        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        public override func deviceOrientationDidChange() {
            super.deviceOrientationDidChange()
            if self == NetWorkStatusView.default {
                self.x(UIEdgeInsets.layoutMargins.left)
                    .width(CGFloat.screenWidth - 2 * UIEdgeInsets.layoutMargins.left)
                    .height(24)
            }
            render()
        }
    }
}

extension CICHUD {
    public class func showNetWorkStatusChange(_ title: String = NetWorkStatusView.defaultTip,
                                              image: UIImage? = nil) {
        NetWorkStatusView.default.removeFromSuperview()
        NetWorkStatusView.default.statusTitle = title
        NetWorkStatusView.default.image = image
        NetWorkStatusView.default.render()
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        keyWindow.addSubview(NetWorkStatusView.default)
        NetWorkStatusView.default.y(NetWorkStatusView.defaultOffset)
            .width(CGFloat.screenWidth - 2 * UIEdgeInsets.layoutMargins.left)
            .height(0)
            .centerX(keyWindow.cic.internalCenterX)
        UIView.animate(withDuration: NetWorkStatusView.defaultAnimationDuration, animations: {
            NetWorkStatusView.default.height(24)
        })
    }

    public class func hideNetWorkStatusChange() {
        UIView.animate(withDuration: NetWorkStatusView.defaultAnimationDuration, animations: {
            NetWorkStatusView.default.height(0)
        }, completion: { finished in
            if finished {
                NetWorkStatusView.default.removeFromSuperview()
            }
        })
    }
}
