//
//  CICAlertView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/19.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  可以自定义的AlertView

import UIKit
import LayoutKit


public class CICAlertView: UIView {
    
    // 内容窗体
    public var contentView = UIView()
    
    // 标题title
    public var contentLabel = UILabel()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        let backgroundView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
    }

}
