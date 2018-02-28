//
//  CICAlertView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/19.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  可以自定义的AlertView

import UIKit

public typealias CICAlertViewAction = ((UIControl) -> Void)

public class CICAlertAction: UIControl {

    var title = ""
    var contentOffSet = UIEdgeInsets.init(top: 2, left: 8, bottom: 2, right: 8)
    fileprivate weak var delegate: CICAlertView?

    var isShowTopLine = false {
        didSet {
            topLine.isHidden = !isShowTopLine
        }
    }
    let topLine = UIView()

    let titleLabel = CICLabel()

    var isShowBottomLine = false {
        didSet {
            bottomLine.isHidden = !isShowBottomLine
        }
    }
    let bottomLine = UIView()

    public convenience init(_ title: String,
                            configure: ((UILabel) -> Void)? = nil,
                            handler: ((UIControl) -> Void)? = nil) {
        self.init(frame: .zero)
        self.title = title
        titleLabel.text(title)
        configure?(titleLabel)

        self.addHandler(for: .touchUpInside, handler: { (ctrl) in
            if let handler = handler {
                handler(ctrl)
            }
            self.delegate?.hide()
        })

        addSubview(topLine)
        isShowTopLine = false
        topLine.backgroundColor(CIComponentKitThemeCurrentConfig.alertSeparatorColor).height(0.5)
        addSubview(bottomLine)
        isShowBottomLine = false
        bottomLine.backgroundColor(CIComponentKitThemeCurrentConfig.alertSeparatorColor).height(0.5)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubview() {
        titleLabel.font(UIFont.cic.preferred(.body)).textColor(CIComponentKitThemeCurrentConfig.textColor)
        addSubview(titleLabel)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.sizeTo(layout: .maxHeight(self.cic.height)).center(self.cic.internalCenter)
        topLine.width(self)
        bottomLine.width(self).y(self.cic.width - 1.0)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let titleWidth = title.cicHeight(size.width - contentOffSet.left - contentOffSet.right,
                                         font: UIFont.cic.systemFont)
        return CGSize.init(width: titleWidth + contentOffSet.left + contentOffSet.right, height: size.height)
    }
}

/// 与系统 `UIAlertController` 效果一致

/*
     let alertView = CICAlertView.init(contentView: nil,
                                        title: String.poemTitle,
                                        content: String.funnyTip + String.poem)
     let action1 = CICAlertAction.init("喜欢ManoBoo") { (_) in
        print("action1")
     }
     let action2 = CICAlertAction.init("喜欢ZRFlower") { (_) in
        print("action2")
     }
     let action3 = CICAlertAction.init("站在此地别走动") { (_) in
        print("action3")
     }
     let action4 = CICAlertAction.init("我去给你买颗橘子树") { (_) in
        print("action4")
     }
     alertView.addAction(action1, action2, action3, action4)
     alertView.show()
 */

public class CICAlertView: CICUIView {

    var title: String = "提示"
    var content: String = ""

    /// CICAlertView 的actions, 超过三个为竖排,与原生 UIAlertController 效果保持一致
    var actions: [CICAlertAction]?

    private var maxHeight: CGFloat {
//        return .screenHeight - 3 * (UIEdgeInsets.layoutMargins.top + UIEdgeInsets.layoutMargins.bottom)
        return .screenHeight - 2 * 50
    }

    private var maxWidth: CGFloat {
//        return .screenWidth - 2 * (UIEdgeInsets.layoutMargins.left + UIEdgeInsets.layoutMargins.right)
        return .screenWidth - 2 * 15 - (UIEdgeInsets.layoutMargins.left + UIEdgeInsets.layoutMargins.right)
    }

    private var marginH: CGFloat = 10
    private var marginV: CGFloat = 10

    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = CICScrollLabel.init(.zero, axis: CICScrollLabel.LayoutAxis.vertical(maxWidth: 250))
    var contentView: UIView?

    fileprivate var cancelButton: CICAlertAction!
    fileprivate var confirmButton: CICAlertAction!

    fileprivate func hide() {
        self.removeFromSuperview()
        UIViewController.cic.setVisibleUserInteractionEnabled(true)
    }

    public init(contentView: UIView? = nil,
                title:String = "提示",
                content:String = "") {
        super.init(frame: .zero)
        layer.cornerRadius = 10.0
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.shadowOffset = CGSize.init(width: 0, height: 3)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        self.contentView = contentView
        self.title = title
        self.content = content

        initSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show() {
        sizeToFit()
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(self)
            self.center(keyWindow.cic.internalCenter)
            UIViewController.cic.setVisibleUserInteractionEnabled(false)
        }
    }

    func initSubviews() {
        self.backgroundColor(CIComponentKitThemeCurrentConfig.alertBackgroundColor)
        titleLabel.font(UIFont.systemFont(ofSize: 20.0)).line(0)
            .textColor(CIComponentKitThemeCurrentConfig.alertMessageColor).textAlignment(.center)
        addSubview(titleLabel)

        contentLabel.label.line(0).font(UIFont.cic.preferred(.body))
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
        addSubview(contentLabel)
        cancelButton = CICAlertAction.init("取消", configure: { (label) in
            label.textColor(CIComponentKitThemeCurrentConfig.cancelColor)
        })
        cancelButton.delegate = self
        addSubview(cancelButton)
        confirmButton = CICAlertAction.init("确定", configure: { (label) in
            label.textColor(CIComponentKitThemeCurrentConfig.confirmColor)
        })
        confirmButton.delegate = self
        addSubview(confirmButton)
    }

    @discardableResult
    func renderActions() -> CGFloat {
        let contentMaxWidth = maxWidth - 2 * marginH
        if let actions = actions {
            cancelButton.isHidden = true
            confirmButton.isHidden = true
            if actions.count > 2 {
                for (index, action) in actions.enumerated() {
                    action.height(44.0).width(self).x(0)
                        .y( (contentView ?? contentLabel).cic.bottom + marginV + CGFloat(index) * 44.0 )
                }
            } else {
                if let action = actions.first {
                    action.x(marginH).width(contentMaxWidth)
                        .y((contentView ?? contentLabel).cic.bottom + marginV).height(44.0)
                }
            }
            return actions.map { $0.cic.bottom }.max()!
        } else {
            cancelButton.isHidden = false
            confirmButton.isHidden = false
            cancelButton.isShowTopLine = false
            confirmButton.isShowTopLine = false
            cancelButton.height(44.0).width(contentMaxWidth/2)
                .centerX(maxWidth * 0.25).y((contentView ?? contentLabel).cic.bottom + marginV)
            confirmButton.height(44.0).width(contentMaxWidth/2)
                .centerX(maxWidth * 0.75).y((contentView ?? contentLabel).cic.bottom + marginV)

            return [cancelButton, confirmButton].map {
                $0?.y( (contentView ?? contentLabel).cic.bottom + marginV)
                return $0!.cic.bottom + marginV
            }.max()!
        }
    }

    @discardableResult
    func render() -> CGSize {
        if isSyncCurrentTheme {
            self.backgroundColor(CIComponentKitThemeCurrentConfig.alertBackgroundColor)
        }
        let contentMaxWidth = maxWidth - 2 * marginH

        titleLabel.y(marginV).width(contentMaxWidth)
            .text(title).sizeTo(layout: .width(contentMaxWidth))
        if let contentView = contentView {
            contentLabel.isHidden = true
            contentView.centerX(self.cic.internalCenterX).y(titleLabel.cic.bottom)
        } else {
            contentLabel.isHidden = false
            contentLabel.axis = .vertical(maxWidth: contentMaxWidth)
            contentLabel.label.text(content)
            contentLabel.y(titleLabel.cic.bottom + marginV).width(contentMaxWidth).sizeToFit()
            contentLabel.layout()
        }

        var autoSizeHeight = renderActions()
        if autoSizeHeight > maxHeight {
            let actionsHeight = CGFloat(actions?.count ?? 1) * 44 + (actions != nil ? 0.00 : marginV)
            contentLabel.height(maxHeight - contentLabel.cic.y - marginV - actionsHeight)
            contentLabel.layout()
            autoSizeHeight = renderActions()
        }
        titleLabel.centerX(maxWidth/2)
        contentLabel.centerX(maxWidth/2)
        return CGSize.init(width: maxWidth, height: autoSizeHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        if let bColor = self.backgroundColor?.cgColor {
            self.backgroundColor = nil
            layer.backgroundColor = bColor
        }
        
        render()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return render()
    }

    public override func didToggleTheme() {
        super.didToggleTheme()

        deviceOrientationDidChange()
    }

    public override func deviceOrientationDidChange() {
        self.sizeToFit()
        if let superView = self.superview {
            self.center(superView.cic.internalCenter)
        }
    }

    /// 类似于UIAlertController addAlertAction
    ///
    /// - Parameter actions: CICAlertAction
    public func addAction(_ actions: CICAlertAction...) {
        _ = actions.map { $0.delegate = self}
        if self.actions == nil {
            self.actions = []
        }
        self.actions?.append(contentsOf: actions)
        _ = self.actions?.map { [weak self] (action)  in
            action.isShowBottomLine = true
            if action.superview == nil {
                self?.addSubview(action)
            }
        }
        self.actions?.first?.isShowTopLine = true
        self.actions?.last?.isShowBottomLine = false
    }
}
