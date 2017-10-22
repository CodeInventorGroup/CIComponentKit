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
    
    public typealias CICAlertViewAction = ((UIControl) -> ())
    
    public init(contentView: UIView? = nil, title:String = "提示", content:String = "", actionTitles: [String] = [], actions: [CICAlertViewAction]? = [], actionStyles: [UIColor]? = nil) {
        
        let titleLabeLayout = LabelLayout.init(text: title, font: UIFont.systemFont(ofSize: 20.0), alignment: .center,viewReuseId: "title") {titleLabel in
            titleLabel.textColor(CIComponentKitThemeCurrentConfig.alertMessageColor)
            titleLabel.textAlignment = .center
        }
    
        let contentInfoLayout = LabelLayout.init(text: content, font: UIFont.cic.preferred(.body), numberOfLines: 0,  alignment: Alignment.center, viewReuseId: "content") { (label) in
            label.textColor(CIComponentKitThemeCurrentConfig.textColor)
        }
        
        var layouts = [Layout]()
        layouts.append(titleLabeLayout)
        layouts.append(contentInfoLayout)
        
        // 初始化buttons
        var actionlayouts = [Layout]()
        for (index, actionTitle) in actionTitles.enumerated() {
            let actionLayout = ButtonLayout.init(type: .custom, title: actionTitle, font: UIFont.systemFont(ofSize: 20.0), contentEdgeInsets: UIEdgeInsetsMake(4, 4, 4, 4), viewReuseId: actionTitle, config: { control in
                if let action = actions?[index] {
                    control.addHandler(for: .touchUpInside, handler: action)
                }
                control.backgroundColor(.black)
            })
            actionlayouts.append(actionLayout)
        }
        if actionlayouts.count > 0 {
            let actionStackLayout = StackLayout.init(axis: .horizontal, spacing: 40.0, distribution: StackLayoutDistribution.fillFlexing, alignment: Alignment.aspectFit, viewReuseId: "actionStack", sublayouts: actionlayouts, config: { view in
            })
            layouts.append(actionStackLayout)
        }
        
        let backgroundLayout = InsetLayout<UIView>.init(insets: UIEdgeInsetsMake(20, 15, 20, 15),
                                                                   viewReuseId: "background",
                                                                   sublayout: StackLayout<UIView>.init(axis: .vertical,
                                                                                                       spacing: 20,
                                                                                                       viewReuseId: "background",
                                                                                                       sublayouts: layouts,
                                                                                                       config: { (background) in
                                                                                                        
                                                                   })) { (background) in
            background.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        }
        
        super.init(minWidth: 100, maxWidth: CGFloat.screenWidth - 40, minHeight: 100, maxHeight: CGFloat.screenHeight - 100, alignment: Alignment.center, viewReuseId: "CICAlert_", sublayout: backgroundLayout) { (view) in
            view.layer.cornerRadius = 8.0
            view.layer.masksToBounds = true
        }
    }
}

extension CICHUD {
    public class func showAlert() {
        if let keyWindow = UIApplication.shared.keyWindow {
            
//            let actionTitles = ["cancel", "confirm", "666", "二蛋"]
//            let actions: [CICAlertViewLayout.CICAlertViewAction] = [{ _ in
//                    print("cancel")
//                }, { _ in
//                    print("confirm")
//                },{ _ in
//                    print("666")
//                },{ _ in
//                    print("二蛋")
//                }]
            
            let actionTitles = ["取消", "确定"]
            let actions: [CICAlertViewLayout.CICAlertViewAction] = [{ _ in
                print("cancel")
                }, { _ in
                    print("confirm")
                }]
            
            let alertLayout = CICAlertViewLayout.init(title: "温馨提示", content: "ManoBoo叫你来巡山ManoBoo叫你来巡山ManoBoo叫你来巡山\nManoBoo叫你来巡山\nManoBoo叫你来巡山😄😄😄", actionTitles: actionTitles, actions: actions)
            let blackMaskLayout = SizeLayout<UIView>.init(size: keyWindow.bounds.size, alignment: Alignment.center, viewReuseId: "alert_blackMask", sublayout: alertLayout, config: { (view) in
                view.backgroundColor(UIColor.cic.hex(hex: 0x000000, alpha: 0.7))
            })
            
            blackMaskLayout.arrangement().makeViews(in: keyWindow)
        }
    }
}


