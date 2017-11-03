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

class RootCardLayout: SizeLayout<VisualEffectView> {
    init(_ title: String, subtitle: String, info: String, size: CGSize, action: @escaping (() -> ())) {
        
        let titleLayout = LabelLayout.init(text: title, font: UIFont.cic.systemFont, numberOfLines: 1, viewReuseId: "title") { (label) in
            
        }
        
        let subtitleLayout = LabelLayout.init(text: subtitle, font: UIFont.boldSystemFont(ofSize: 20.0), numberOfLines: 0, viewReuseId: "subtitle") { (label) in
            
        }
        
    
        let infoHeight = info.cicHeight(size.width, font: UIFont.cic.preferred(.body))
        let infoLayout = SizeLayout<CICLabel>.init(height: infoHeight) { (label) in
            label.line(0)
                .text(info)
                .font(UIFont.preferredFont(forTextStyle: .body))
                .sizeTo(layout: .maxWidth(.screenWidth))
                .textColor(CIComponentKitThemeCurrentConfig.textColor)
                .longPressAction(.copy)
                .copyRange(NSMakeRange(0, info.count))
            label.copySuccessClousure = {
                let tips = """
                            嫉妒使我高斯模糊

                            嫉妒使我氧化分解

                            嫉妒使我增减反同

                            嫉妒使我奇变偶不变符号看象限

                            嫉妒使我基因突变

                            嫉妒使我质壁分离

                            嫉妒使我泰拳警告

                            嫉妒使我弥散性血管内凝血
                           """
                CICHUD.showAlert("羡慕使我嫉妒", content: tips, cancelAction: { (_) in
                    CICHUD.showNotifier(title: "爱酱今天要元气满满哦~")
                }, confirmAction: { (_) in
                        CICHUD.showActivityView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            CICHUD.hideActivityView()
                        }
                })
            }
        }
    
        let stackLayout = StackLayout<UIControl>.init(axis: .vertical,
                                                      spacing: 30,
                                                      sublayouts: [titleLayout, subtitleLayout, infoLayout]) { (control) in
                                                        control.addHandler(for: .touchUpInside, handler: { (_) in
                                                            action()
                                                        })
        }
        

        super.init(minWidth: size.width,
                   maxWidth: size.width,
                   maxHeight: size.height,
                   alignment: .center,
                   sublayout: InsetLayout.init(insets: UIEdgeInsetsMake(5, 5, 5, 5), sublayout: stackLayout)) { (view) in
            view.layer.cornerRadius = 6.0
            view.layer.masksToBounds = true
            view.layer.shadowColor = UIColor.white.cgColor
            view.effect = UIBlurEffect.init(style: .extraLight)
        }
    }
}

class VisualEffectView: UIVisualEffectView {
    override func addSubview(_ view: UIView) {
        if view is UIControl {
            self.contentView.addSubview(view)
        }else {
            super.addSubview(view)
        }
    }
}

