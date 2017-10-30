//
//  RootCard.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/10/27.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit
import LayoutKit
import CIComponentKit

class RootCard: UIView {
    
    var title: String = ""
    
    var subtitle: String = ""
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let contentView = UIVisualEffectView.init(frame: .zero)
    
    init(_ title: String, subtitle: String) {
        super.init(frame: .zero)
        
        self.title = title
        self.subtitle = subtitle
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubviews() {
        
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.white.cgColor
        
        contentView.effect = UIBlurEffect(style: .extraLight)
        self.addSubview(contentView)
        
        titleLabel.x(10)
            .y(20)
            .font(UIFont.systemFont(ofSize: 16.0))
            .text(title)
            .textColor(.black)
            .sizeTo(layout: .height(16.0))
        contentView.contentView.addSubview(titleLabel)
        
        subtitleLabel.x(10)
            .y(titleLabel.cic.bottom + 20)
            .font(UIFont.boldSystemFont(ofSize: 16.0))
            .text(subtitle)
            .textColor(.black)
            .sizeTo(layout: .maxWidth(.screenWidth - 40))
        contentView.contentView.addSubview(subtitleLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame(self.bounds)
    }
}

class RootCardLayout: SizeLayout<View> {
    init(_ title: String, subtitle: String, info: String, size: CGSize = CGSize(width: .screenWidth, height: 200), action: @escaping (() -> ())) {
        
        let titleLayout = LabelLayout.init(text: title, font: UIFont.cic.systemFont, numberOfLines: 1, viewReuseId: "title") { (label) in
            
        }
        
        let subtitleLayout = LabelLayout.init(text: subtitle, font: UIFont.boldSystemFont(ofSize: 20.0), numberOfLines: 0, viewReuseId: "subtitle") { (label) in
            
        }
        
        let infoLayout = LabelLayout.init(text: info, font: UIFont.cic.preferred(.body), numberOfLines: 0, viewReuseId: "info") { (label) in
            
        }
        
    
        let stackLayout = StackLayout<UIControl>.init(axis: .vertical,
                                                      spacing: 30,
                                                      viewReuseId: "control",
                                                      sublayouts: [titleLayout, subtitleLayout, infoLayout]) { (control) in
                                                        control.addHandler(for: .touchUpInside, handler: { (_) in
                                                            action()
                                                        })
        }
        

        super.init(minWidth: size.width, maxWidth: size.width, minHeight: size.height, alignment: .center, sublayout: stackLayout) { (view) in
            view.layer.cornerRadius = 6.0
//            view.effect = UIBlurEffect.init(style: .extraLight)
        }
    }
}

