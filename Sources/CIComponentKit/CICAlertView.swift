//
//  CICAlertView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/19.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  可以自定义的AlertView

import UIKit
import LayoutKit


//public class CICAlertView: UIView {
//
//    // 内容窗体
//    public var contentView = UIView()
//
//    // 标题title
//    public var contentLabel = UILabel()
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        initSubviews()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func initSubviews() {
//        let backgroundView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
//    }
//}

public class CICAlertViewLayout: InsetLayout<UIView> {
    
    public init(contentView: UIView? = nil, title:String = "提示", content:String = "") {
        
        let contentLayout = LabelLayout.init(text: content, font: UIFont.cic.preferred(.body), numberOfLines: 0, viewReuseId: "content") { (label) in
            
        }
        
        let backgroundLayout = SizeLayout<UIVisualEffectView>.init(width: 200, height: 200, viewReuseId: "background", sublayout: contentLayout) { (blurView) in
            blurView.effect = UIBlurEffect.init(style: .extraLight)
        }
        
        super.init(insets: .zero, alignment: Alignment.topLeading, viewReuseId: "CICAlert", sublayout: backgroundLayout) { (view) in
            
        }
    }
}


