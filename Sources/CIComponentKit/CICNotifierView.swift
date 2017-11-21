//
//  CICNotifierView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/24.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  类似于iOS原生顶部通知

import UIKit
import LayoutKit

public struct CICNotifierViewType: Hashable {

    // 提供四种样式
    public static let error = CICNotifierViewType("error_circle", color: UIColor.cic.hex(hex: 0xF85359))
    public static let status = CICNotifierViewType("status_circle", color: UIColor.cic.hex(hex: 0x1991EB))
    public static let success = CICNotifierViewType("right_circle", color: UIColor.cic.hex(hex: 0x39B54A))
    public static let warning = CICNotifierViewType("status_circle", color: UIColor.cic.hex(hex: 0xF7981C))

    var image: UIImage?
    var color: UIColor
    var textColor: UIColor
    fileprivate var imageName: String

    /// CICNotifierViewType init
    ///
    /// - Parameters:
    ///   - imageNamed: 图片名称
    ///   - color: 背景颜色
    ///   - textColor: 文字颜色
    public init(_ imageNamed: String, color: UIColor = UIColor.cic.hex(hex: 0x39B54A), textColor: UIColor = .white) {
        self.imageName = imageNamed
        self.color = color
        self.textColor = textColor
        self.image = UIImage.init(named: imageNamed)
    }

    public var hashValue: Int {
        return (imageName + String.cic.random()).hashValue
    }

    public static func == (lhs: CICNotifierViewType, rhs: CICNotifierViewType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class CICNotifierViewLayout: SizeLayout<View> {

    ///
    ///
    /// - Parameters:
    ///   - image: image
    ///   - title: title
    ///   - isShowClose: 展示关闭按钮
    ///   - autoHide: 是否自动隐藏
    public init(type: CICNotifierViewType = .status,
                title: String = "",
                isShowClose: Bool = true,
                viewReuseId: String) {
        let imageLayout = SizeLayout<UIImageView>.init(width: 20,
                                                       height: 20,
                                                       alignment: .center,
                                                       viewReuseId: "imageLayout",
                                                       sublayout: nil) { (imageView) in
            switch (type) {
            case .error, .status, .success, .warning:
                imageView.image = UIImage.cic.bundle(type.imageName)
            default:
                imageView.image = type.image
            }
        }
        let titleLabelLayout = LabelLayout.init(text: title,
                                                font: UIFont.cic.preferred(.body),
                                                numberOfLines: 0,
                                                alignment: .center,
                                                viewReuseId: "title") { (label) in
            label.textColor(type.textColor)
        }
        let closeButtonLayout = SizeLayout<UIButton>.init(width: 20,
                                                          height: 20,
                                                          alignment: .center,
                                                          viewReuseId: "closeButton",
                                                          sublayout: nil) { (button) in
            button.contentEdgeInsets = 6.makeEdgeInsets
            button.setImage(UIImage.cic.bundle("close_notifier"), for: .normal)
            button.addHandler(for: .touchUpInside, handler: { (_) in
                CICHUD.toast("点击了X", blurStyle: .extraLight)
            })
        }
        let infoLayout = StackLayout<View>.init(axis: .horizontal,
                                                spacing: 20,
                                                alignment: .center,
                                                viewReuseId: "content",
                                                sublayouts: [imageLayout, titleLabelLayout])

        let contentLayout = StackLayout<View>.init(axis: .horizontal,
                                                   spacing: 20.0,
                                                   distribution: StackLayoutDistribution.fillEqualSpacing,
                                                   alignment: Alignment.center,
                                                   viewReuseId: "content",
                                                   sublayouts: [infoLayout, closeButtonLayout])
        super.init(minWidth: CGFloat.screenWidth - 20,
                   maxWidth: CGFloat.screenWidth - 20,
                   minHeight: 44,
                   maxHeight: 100,
                   alignment: .center,
                   viewReuseId: viewReuseId,
                   sublayout: contentLayout) { (view) in
            view.backgroundColor(type.color)
            view.layer.shadowColor = type.color.cgColor
            view.layer.cornerRadius = 8.0
        }
    }
}

extension CICHUD {

    /// 弹出一个通知窗体
    ///
    /// - Parameters:
    ///   - type: CICNotifierViewType, 可自定义 CICNotifierViewType.init(....)
    ///   - title: 展示的文本
    ///   - offSet: 距离屏幕上方的offSet
    ///   - isShowClose: 是否展示右侧关闭按钮
    ///   - autoHide: 是否自动隐藏
    ///   - duration: autoHide为true时,弹出和隐藏的动画时间
    public class func showNotifier(_ type: CICNotifierViewType = .status,
                                   title: String,
                                   offSet: CGFloat? = nil,
                                   leftOffSet: CGFloat = 10,
                                   isShowClose: Bool = true,
                                   autoHide: Bool = true,
                                   duration: TimeInterval = 2.0) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let randomid = String.cic.random()
        let notifierLayout = CICNotifierViewLayout.init(type: type,
                                                        title: title,
                                                        isShowClose: isShowClose,
                                                        viewReuseId: randomid)
        let top = offSet ?? CGFloat.maximum(keyWindow.layoutMargins.top, 20)
        let height = notifierLayout.arrangement(width: CGFloat.screenWidth - 20).frame.height
        let notifier = notifierLayout.arrangement(origin: CGPoint.init(x: leftOffSet, y: -height),
                                                  width: CGFloat.screenWidth - 2 * leftOffSet,
                                                  height: nil).makeViews()
        keyWindow.addSubview(notifier)
        UIView.cic.spring ({
            notifier.y(top)
        })
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                UIView.cic.spring({
                    notifier.y(-notifier.cic.height)
                }, completion: {
                    notifier.removeFromSuperview()
                })
            })
        }
    }
}
