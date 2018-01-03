//
//  CICNotifierView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/24.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  类似于iOS原生顶部通知

import UIKit

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
        return imageName.hashValue + textColor.hashValue
    }

    public static func == (lhs: CICNotifierViewType, rhs: CICNotifierViewType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class CICNotifierView: CICUIView {

    private let imageView = UIImageView().size(20.0.makeSize)
    private let titleLabel = CICLabel().font(UIFont.cic.preferred(.body)).line(0)
    private let closeBtn = UIButton().size(20.0.makeSize)

    convenience init(type: CICNotifierViewType = .status,
                     title: String = "",
                     isShowClose: Bool = true,
                     closeHandler: ((UIControl) -> Void)? = nil) {
        self.init(frame: .zero)
        self.backgroundColor(type.color)
        self.layer.shadowColor = type.color.cgColor
        self.layer.cornerRadius = 10.0
        initSubviews()

        switch (type) {
        case .error, .status, .success, .warning:
            imageView.image = UIImage.cic.bundle(type.imageName)
        default:
            imageView.image = type.image
        }
        titleLabel.textColor(type.textColor).text(title).textAlignment(.center)
        closeBtn.isHidden = !(isShowClose)
        closeBtn.contentEdgeInsets = 6.makeEdgeInsets
        closeBtn.setImage(UIImage.cic.bundle("close_notifier"), for: .normal)
        if let closeHandler = closeHandler {
            closeBtn.addHandler(for: .touchUpInside, handler: closeHandler)
        }
    }

    func initSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(closeBtn)
    }

    func render() {
        imageView.x(20).centerY(self.cic.internalCenterY)
        closeBtn.right(20.0).centerY(self.cic.internalCenterY)
        let maxTitleWidth = closeBtn.cic.x - imageView.cic.right - 20
        titleLabel.x(imageView.cic.right + 20).width(maxTitleWidth)
            .sizeTo(layout: .maxWidth(maxTitleWidth))
            .centerY(self.cic.internalCenterY)
            .width(maxTitleWidth)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        render()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.width(size.width)
        render()
        return CGSize.init(width: size.width, height: titleLabel.cic.height + 22)
    }

    override func deviceOrientationDidChange() {
        super.deviceOrientationDidChange()

        sizeToFit()
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
                                   duration: TimeInterval = 2.0,
                                   closeHandler: ((UIControl) -> Void)? = nil) {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }

        let notifier = CICNotifierView.init(type: type,
                                                title: title,
                                                isShowClose: isShowClose,
                                                closeHandler: closeHandler)
        notifier.x(10).width(CGFloat.screenWidth - 20).sizeToFit()
        notifier.y(-notifier.cic.height)
        let top = offSet ?? CGFloat.maximum(keyWindow.layoutMargins.top, 20)
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
