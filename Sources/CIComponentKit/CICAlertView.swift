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
    
    let titleLabel = UILabel()
    var title = ""
    var contentOffSet = UIEdgeInsets.init(top: 2, left: 8, bottom: 2, right: 8)
    convenience init(_ title: String, _ configure: ((UILabel) -> ())? = nil, handler: ((CICAlertAction) -> ())? = nil) {
        self.init(frame: .zero)
        self.title = title
        titleLabel.text(title)
        configure?(titleLabel)
        self.backgroundColor(UIColor.cic.random)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        titleLabel.font(UIFont.cic.systemFont).textColor(CIComponentKitThemeCurrentConfig.textColor)
        addSubview(titleLabel)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeTo(layout: .maxHeight(self.cic.height)).center(self.cic.internalCenter)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let titleWidth = title.cicHeight(size.width - contentOffSet.left - contentOffSet.right, font: UIFont.cic.systemFont)
        return CGSize.init(width: titleWidth + contentOffSet.left + contentOffSet.right, height: size.height)
    }
}

public class CICAlertView: CICUIView {

    var title: String = "提示"
    var content: String = ""
    var actions: [CICAlertAction]?

    private var maxHeight: CGFloat {
        return .screenHeight - 2 * (UIEdgeInsets.layoutMargins.top + UIEdgeInsets.layoutMargins.bottom)
    }

    private var maxWidth: CGFloat {
        return .screenWidth - 2 * (UIEdgeInsets.layoutMargins.left + UIEdgeInsets.layoutMargins.right)
    }

    private var marginH: CGFloat = 10
    private var marginV: CGFloat = 10

    fileprivate let titleLabel = UILabel()
    fileprivate let contentLabel = CICScrollLabel.init(.zero, axis: CICScrollLabel.LayoutAxis.vertical(maxWidth: 250))
    var contentView: UIView?
    
    fileprivate let cancelButton = CICAlertAction.init("取消", { (label) in
        label.textColor(CIComponentKitThemeCurrentConfig.cancelColor)
    }) { (_) in
        
    }
    
    fileprivate let confirmButton = CICAlertAction.init("确定", { (label) in
        label.textColor(CIComponentKitThemeCurrentConfig.confirmColor)
    }) { (_) in
        
    }

    deinit {
        print("CICAlertView deinit")
    }

    public init(contentView: UIView? = nil,
                title:String = "提示",
                content:String = "") {
        super.init(frame: .zero)
        self.layer.cornerRadius = 6.0
        self.contentView = contentView
        self.title = title
        self.content = content
    
        initSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubviews() {
        titleLabel.font(UIFont.systemFont(ofSize: 20.0)).line(0)
            .textColor(CIComponentKitThemeCurrentConfig.alertMessageColor).textAlignment(.center)
        addSubview(titleLabel)

        contentLabel.label.line(0).font(UIFont.cic.preferred(.body))
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
        addSubview(contentLabel)
        addSubview(cancelButton)
        addSubview(confirmButton)
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
        if let actions = actions {
            print(actions)
        } else {
            cancelButton.height(44.0).width(contentMaxWidth/2)
                .centerX(maxWidth * 0.25).y((contentView ?? contentLabel).cic.bottom + marginV)
            confirmButton.height(44.0).width(contentMaxWidth/2)
                .centerX(maxWidth * 0.75).y((contentView ?? contentLabel).cic.bottom + marginV)
        }
    
        let autoSizeHeight = (actions ?? [cancelButton, confirmButton]).map{ $0.cic.bottom + marginV}.max() ?? maxHeight
        if autoSizeHeight > maxHeight {
            contentLabel.height(maxHeight - marginV - cancelButton.cic.height - titleLabel.cic.bottom - marginV)
            contentLabel.layout()
            _ = [cancelButton, confirmButton].map{ $0.y(contentLabel.cic.bottom + marginV) }
        }
        titleLabel.centerX(maxWidth/2)
        contentLabel.centerX(maxWidth/2).backgroundColor(.green)
        return CGSize.init(width: maxWidth, height: min(autoSizeHeight, maxHeight))
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        render()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return render()
    }
    
    public override func deviceOrientationDidChange() {
        self.size(render())
        if let superView = self.superview {
            self.center(superView.cic.internalCenter)
        }
    }
    
    /// 类似于UIAlertController addAlertAction
    ///
    /// - Parameter actions: CICAlertAction
    func addAction(_ actions: CICAlertAction...) {
        self.actions?.append(contentsOf: actions)
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
