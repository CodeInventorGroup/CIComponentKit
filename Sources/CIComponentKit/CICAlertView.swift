//
//  CICAlertView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/19.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  可以自定义的AlertView

import UIKit
import LayoutKit

public class CICAlertViewLayout: SizeLayout<UIView> {
    deinit {
        print("CICAlertViewLayout deinit")
    }
    
    public typealias CICAlertViewAction = ((UIControl) -> ())
    
    public init(contentView: UIView? = nil, title:String = "提示", content:String = "", actionTitles: [String] = [], actions: [CICAlertViewAction]? = [], actionStyles: [UIColor]? = nil) {
        
        let titleLabeLayout = InsetLayout<UIView>.init(insets: UIEdgeInsetsMake(8, 0, 8, 0),
                                 alignment: .center,
                                 viewReuseId: "titleLayout",
                                 sublayout: LabelLayout.init(text: title,
                                                             font: UIFont.systemFont(ofSize: 20.0),
                                                             alignment: .center,
                                                             viewReuseId: "title") {titleLabel in
                                    titleLabel.textColor(CIComponentKitThemeCurrentConfig.alertMessageColor)
                                    titleLabel.textAlignment = .center
        }) { (view) in
            
        }
    
        let contentInfoLayout = InsetLayout<UIView>.init(insets: UIEdgeInsetsMake(0, 15, 0, 15),
                                                         alignment: .center,
                                                         viewReuseId: "content",
                                                         sublayout: LabelLayout.init(text: content,
                                                                                     font: UIFont.cic.preferred(.body),
                                                                                     numberOfLines: 0,
                                                                                     alignment: .center,
                                                                                     viewReuseId: "contentInfo") { (label) in
                                                            label.textColor(CIComponentKitThemeCurrentConfig.textColor)
        }) { (view) in
            
        }
        
        var layouts = [Layout]()
        layouts.append(titleLabeLayout)
        layouts.append(contentInfoLayout)
        
        // 初始化buttons
        var actionlayouts = [Layout]()
        for (index, actionTitle) in actionTitles.enumerated() {
            let actionLayout = ButtonLayout.init(type: .custom, title: actionTitle, font: UIFont.systemFont(ofSize: 20.0), contentEdgeInsets: UIEdgeInsetsMake(6, 10, 6, 10), viewReuseId: actionTitle, config: { control in
                if let titleColor = actionStyles?.safeElement(at: index) {
                    control.setTitleColor(titleColor, for: .normal)
                }else {
                    // 默认提供一个字体
                    control.setTitleColor(CIComponentKitThemeCurrentConfig.confirmColor, for: .normal)
                }
                if let action = actions?.safeElement(at: index){
                    control.addHandler(for: .touchUpInside, handler: action)
                }
            })
            actionlayouts.append(actionLayout)
        }
        if actionlayouts.count > 0 {
            let spacing: CGFloat = actionlayouts.count < 3 ? 100.0 : 50.0
            let actionStackLayout = StackLayout.init(axis: .horizontal, spacing: spacing, distribution: StackLayoutDistribution.center, alignment: Alignment.fill, viewReuseId: "actionStack", sublayouts: actionlayouts, config: { view in
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
                                                                                                       config: { (background) in
                                                                                                        
                                                                   })) { (background) in
            background.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        }
        
        super.init(minWidth: 250, maxWidth: CGFloat.screenWidth - 40, minHeight: 100, maxHeight: CGFloat.screenHeight - 100, alignment: Alignment.center, viewReuseId: "CICAlert_", sublayout: backgroundLayout) { (view) in
            view.layer.cornerRadius = 8.0
            view.layer.masksToBounds = true
        }
    }
}

extension CICHUD {
    public class func showAlert(_ title: String = "提示",
                                content: String = "",
                                cancelAction: @escaping CICAlertViewLayout.CICAlertViewAction = {_ in },
                                confirmAction: @escaping CICAlertViewLayout.CICAlertViewAction = {_ in}) {
        if let keyWindow = UIApplication.shared.keyWindow {
        
            var alertMaskView = UIView()
            let actionTitles = ["取消", "确定"]
            let actions: [CICAlertViewLayout.CICAlertViewAction] = [{ (control) in
                    print("cancel")
                    cancelAction(control)
                    alertMaskView.removeFromSuperview()
                }, { control in
                    print("confirm")
                    confirmAction(control)
                    alertMaskView.removeFromSuperview()
                }]
            let actionStyles = [CIComponentKitThemeCurrentConfig.cancelColor, CIComponentKitThemeCurrentConfig.confirmColor]
            
            let alertLayout = CICAlertViewLayout.init(title: "提示",
                                                      content: content,
                                                      actionTitles: actionTitles,
                                                      actions: actions,
                                                      actionStyles: actionStyles)
            let blackMaskLayout = SizeLayout<UIView>.init(size: keyWindow.bounds.size, alignment: Alignment.center, viewReuseId: "alert_blackMask", sublayout: alertLayout, config: { (view) in
                view.backgroundColor(UIColor.cic.hex(hex: 0x000000, alpha: 0.7))
            })
            alertMaskView = blackMaskLayout.arrangement().makeViews()
            keyWindow.addSubview(alertMaskView)
        }
        
    }
}


