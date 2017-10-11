//
//  CICHUD+Network.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/9/30.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  网络情况的HUD, 比如 正在连接 etc.

import UIKit
import LayoutKit
import SnapKit

public var CICHUD_NetWorkStatusDefaultTip = "您已失去网络连接"
public var CICHUD_NetWorkStatusDefaultOffset: CGFloat = 64
public var CICHUD_NetWorkStatusAnimationDurationInterval = 0.75

public class CICHUD_NetWorkStatusView: UIView {
    
    static let `default` = CICHUD_NetWorkStatusView.init(frame: .zero)
    
    public var statusTitle: String = CICHUD_NetWorkStatusDefaultTip {
        didSet {
            statusLabel.text(statusTitle).sizeTo(layout: UIView.CICLayoutType.maxWidth(CGFloat.screenWidth - 80))
        }
    }
    public var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    let imageView = UIImageView()
    let statusLabel = UILabel()
    
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
        
        statusLabel.text(statusTitle)
            .font(UIFont.cic.systemFont)
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
        statusLabel.line()
            .x(imageView.frame.maxX + 15)
            .height(20)
            .centerY(12)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 9.0, *)
extension CICHUD {
    public class func showNetWorkStatusChange(_ title: String = CICHUD_NetWorkStatusDefaultTip, _ image: UIImage? = nil) {
        CICHUD_NetWorkStatusView.default.removeFromSuperview()
        CICHUD_NetWorkStatusView.default.statusTitle = title
        CICHUD_NetWorkStatusView.default.image = image
        CICHUD_NetWorkStatusView.default.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        CICHUD_NetWorkStatusView.default.statusLabel.textColor(CIComponentKitThemeCurrentConfig.tintColor)
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(CICHUD_NetWorkStatusView.default)
            CICHUD_NetWorkStatusView.default.y(CICHUD_NetWorkStatusDefaultOffset).width(CGFloat.screenWidth).height(0)
            UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
                CICHUD_NetWorkStatusView.default.height(24)
            }, completion: {finished in
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//                    CICHUD_NetWorkStatusView.default.statusTitle = "连接成功"
//                })
            })
        }
    }
    
    public class func hideNetWorkStatusChange() {
        UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
            CICHUD_NetWorkStatusView.default.height(0)
        }) { (finished) in
            if finished {
                CICHUD_NetWorkStatusView.default.removeFromSuperview()
            }
        }
    }
}

//public class NetWorkStatusLayout: InsetLayout<UIView> {
//
//    public init(image: UIImage?, status: String) {
//        let imageLayout = SizeLayout<UIImageView>(
//            width: 20,
//            height: 20,
//            alignment: .center,
//            config: { imageView in
//                imageView.image = image
//            }
//        )
//        let statusLabelLayout = LabelLayout.init(text: status, font: UIFont.cic.systemFont) { (label) in
//            label.textColor(UIColor.black)
//        }
//        super.init(
//            insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
//            sublayout: StackLayout(
//                axis: .horizontal,
//                spacing: 8,
//                alignment: .center,
//                sublayouts: [
//                    imageLayout,
//                    statusLabelLayout
//                ]
//            ),
//            config: { view in
//                view.layer.cornerRadius = 2.0
//                view.layer.backgroundColor = UIColor.white.cgColor
//                view.clipsToBounds = true
//            }
//        )
//    }
//}
//
//var DefaultNetWorkStatusLayout = NetWorkStatusLayout.init(image: nil, status: CICHUD_NetWorkStatusDefaultTip)
//var NetWorkStatusView = DefaultNetWorkStatusLayout.arrangement(origin: CGPoint.init(x: 0, y: CICHUD_NetWorkStatusDefaultOffset), width: CGFloat.screenWidth, height: 24).makeViews()
//
//@available(iOS 9.0, *)
//extension CICHUD {
//
//    /// display loading hud
//    public class func networkFaild(_ title: String = "您已失去网络连接") {
//        NetWorkStatusView.removeFromSuperview()
//        DispatchQueue.main.async {
//            if title == CICHUD_NetWorkStatusDefaultTip {
//                NetWorkStatusView = DefaultNetWorkStatusLayout.arrangement(origin: CGPoint.init(x: 0, y: CICHUD_NetWorkStatusDefaultOffset), width: CGFloat.screenWidth, height: 24).makeViews()
//            }else {
//                NetWorkStatusView = NetWorkStatusLayout.init(image: nil, status: title).arrangement(origin: CGPoint.init(x: 0, y: CICHUD_NetWorkStatusDefaultOffset), width: CGFloat.screenWidth, height: 24).makeViews()
//            }
//            if let keyWindow = UIApplication.shared.keyWindow {
//                NetWorkStatusView.height(0)
//                keyWindow.addSubview(NetWorkStatusView)
//                UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
//                    NetWorkStatusView.height(24)
//                })
//            }
//        }
//    }
//
//    /// hideStatusWithAnimation
//    public class func hideNetworkStatus() {
//        UIView.animate(withDuration: CICHUD_NetWorkStatusAnimationDurationInterval, animations: {
//            NetWorkStatusView.height(0)
//        }) { (finished) in
//            if finished {
//                NetWorkStatusView.removeFromSuperview()
//            }
//        }
//    }
//}

