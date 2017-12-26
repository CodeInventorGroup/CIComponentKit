//
//  CICAlertView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/19.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  可以自定义的AlertView

import UIKit
import LayoutKit

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

    let titleLabel = UILabel()

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
//        self.backgroundColor(UIColor.cic.random)

        if let handler = handler {
            self.addHandler(for: .touchUpInside, handler: { (ctrl) in
                handler(ctrl)
                self.delegate?.hide()
            })
        }
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

public class CICAlertView: CICUIView {

    var title: String = "提示"
    var content: String = ""

    /// CICAlertView 的actions, 超过三个为竖排,与原生 UIAlertController 效果保持一致
    var actions: [CICAlertAction]?

    private var maxHeight: CGFloat {
        return .screenHeight - 3 * (UIEdgeInsets.layoutMargins.top + UIEdgeInsets.layoutMargins.bottom)
    }

    private var maxWidth: CGFloat {
        return .screenWidth - 2 * (UIEdgeInsets.layoutMargins.left + UIEdgeInsets.layoutMargins.right)
    }

    private var marginH: CGFloat = 10
    private var marginV: CGFloat = 10

    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = CICScrollLabel.init(.zero, axis: CICScrollLabel.LayoutAxis.vertical(maxWidth: 250))
    var contentView: UIView?

    fileprivate var cancelButton: CICAlertAction!
    fileprivate var confirmButton: CICAlertAction!

    fileprivate func hide() { self.removeFromSuperview() }

    public init(contentView: UIView? = nil,
                title:String = "提示",
                content:String = "") {
        super.init(frame: .zero)
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
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
        }
    }

    func initSubviews() {
        titleLabel.font(UIFont.systemFont(ofSize: 20.0)).line(0)
            .textColor(CIComponentKitThemeCurrentConfig.alertMessageColor).textAlignment(.center)
        addSubview(titleLabel)

        contentLabel.label.line(0).font(UIFont.cic.preferred(.body))
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
        addSubview(contentLabel)
        cancelButton = CICAlertAction.init("取消", configure: { (label) in
            label.textColor(CIComponentKitThemeCurrentConfig.cancelColor)
        }, handler: { [weak self] (_) in
            print(self)
//            self?.removeFromSuperview()
        })
        cancelButton.delegate = self
        addSubview(cancelButton)
        confirmButton = CICAlertAction.init("确定", configure: { (label) in
            label.textColor(CIComponentKitThemeCurrentConfig.confirmColor)
        }, handler: { [weak self] (_) in
            print(self)
//            self?.removeFromSuperview()
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
            self.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
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
        contentLabel.centerX(maxWidth/2).backgroundColor(.green)
        return CGSize.init(width: maxWidth, height: autoSizeHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

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

public class CICAlertViewLayout: SizeLayout<UIView> {
    deinit {
        print("CICAlertViewLayout deinit")
    }

    public typealias CICAlertViewAction = ((UIControl) -> Void)
    
    public init(contentView: UIView? = nil,
                title:String = "提示",
                content:String = "",
                actionTitles: [String] = [],
                actions: [CICAlertViewAction]? = [],
                actionStyles: [UIColor]? = nil,
                maxHeight: CGFloat = .screenHeight - 2 * UIEdgeInsets.layoutMargins.top) {

        let titleLabeLayout = InsetLayout<UIView>.init(insets: UIEdgeInsetsMake(8, 0, 8, 0),
                                 alignment: .center,
                                 viewReuseId: "titleLayout",
                                 sublayout: LabelLayout.init(text: title,
                                                             font: UIFont.systemFont(ofSize: 20.0),
                                                             alignment: .center,
                                                             viewReuseId: "title") {titleLabel in
                                    titleLabel.textColor(CIComponentKitThemeCurrentConfig.alertMessageColor)
                                    titleLabel.textAlignment = .center
                                 }) { (_) in

        }
        let contentInfoLayout = InsetLayout<UIView>.init(insets: UIEdgeInsetsMake(0, 15, 0, 15),
                                                         alignment: .center,
                                                         viewReuseId: "content",
                                                         sublayout: LabelLayout.init(text: content,
                                                                                     font: UIFont.cic.preferred(.body),
                                                                                     numberOfLines: 0,
                                                                                     alignment: .center,
                                                                                     viewReuseId: "contentInfo") { label in
                                                            label.textColor(CIComponentKitThemeCurrentConfig.textColor)
        }) { (_) in

        }
        
        var layouts = [Layout]()
        layouts.append(titleLabeLayout)
        layouts.append(contentInfoLayout)

        // 初始化buttons
        var actionlayouts = [Layout]()
        for (index, actionTitle) in actionTitles.enumerated() {
            let actionLayout = ButtonLayout.init(type: .custom,
                                                 title: actionTitle,
                                                 font: UIFont.systemFont(ofSize: 20.0),
                                                 contentEdgeInsets: UIEdgeInsets.init(top: 6, left: 10, bottom: 6, right: 10),
                                                 viewReuseId: actionTitle,
                                                 config: { control in
                control.setTitleColor(actionStyles?.safeElement(at: index) ?? CIComponentKitThemeCurrentConfig.confirmColor,
                                      for: .normal)
                if let action = actions?.safeElement(at: index) {
                    control.addHandler(for: .touchUpInside, handler: action)
                }
            })
            actionlayouts.append(actionLayout)
        }
        if !(actionlayouts.isEmpty) {
            let spacing: CGFloat = actionlayouts.count < 3 ? 80 : 40.0
            let actionStackLayout = StackLayout.init(axis: .horizontal,
                                                     spacing: spacing,
                                                     distribution: .center,
                                                     viewReuseId: "actionStack",
                                                     sublayouts: actionlayouts, config: { view in
                view.backgroundColor(.white)
            })
            layouts.append(actionStackLayout)
        }
        let backgroundLayout = InsetLayout<UIView>.init(insets: .zero,
                                                        viewReuseId: "background",
                                                        sublayout: StackLayout<UIView>.init(axis: .vertical,
                                                                                           spacing: 20,
                                                                                           viewReuseId: "background",
                                                                                           sublayouts: layouts,
                                                                                           config: { _ in
                                                                                                        
                                                                   })) { (background) in
            background.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        }
        
        super.init(minWidth: 250,
                   maxWidth: CGFloat.screenWidth - 2 * UIEdgeInsets.layoutMargins.left,
                   minHeight: 100,
                   maxHeight: maxHeight,
                   alignment: Alignment.center,
                   viewReuseId: "CICAlert_",
                   sublayout: backgroundLayout) { (view) in
            view.layer.cornerRadius = 8.0
            view.layer.masksToBounds = true
        }
    }
}

extension CICHUD {
    public class func showAlert(_ title: String = "提示",
                                content: String = "",
                                actionTitles: [String] = ["取消", "确定"],
                                cancelAction: @escaping CICAlertViewLayout.CICAlertViewAction = {_ in },
                                confirmAction: @escaping CICAlertViewLayout.CICAlertViewAction = {_ in}) {
        if let keyWindow = UIApplication.shared.keyWindow {

            var alertMaskView = UIView()
            let actionTitles = ["取消", "确定"]
            let actions: [CICAlertViewLayout.CICAlertViewAction] = [ { control in
                                                                        print("cancel")
                                                                        cancelAction(control)
                                                                        alertMaskView.removeFromSuperview()
                                                                    }, { control in
                                                                        print("confirm")
                                                                        confirmAction(control)
                                                                        alertMaskView.removeFromSuperview()
                                                                    } ]
            let actionStyles = [CIComponentKitThemeCurrentConfig.cancelColor,
                                CIComponentKitThemeCurrentConfig.confirmColor]
            let alertLayout = CICAlertViewLayout.init(title: title,
                                                      content: content,
                                                      actionTitles: actionTitles,
                                                      actions: actions,
                                                      actionStyles: actionStyles)
            let blackMaskLayout = SizeLayout<UIView>.init(size: keyWindow.bounds.size,
                                                          alignment: Alignment.center,
                                                          viewReuseId: "alert_blackMask",
                                                          sublayout: alertLayout,
                                                          config: { (view) in
                view.backgroundColor(UIColor.cic.hex(hex: 0x000000, alpha: 0.7))
            })
            DispatchQueue.main.async {
                alertMaskView = blackMaskLayout.arrangement().makeViews()
                keyWindow.addSubview(alertMaskView)
            }
        }
    }
}
