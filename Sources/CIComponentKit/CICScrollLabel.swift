//
//  CICScrollLabel.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/11/13.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  超过文字可以滑动

import UIKit

public class CICScrollLabel: CICUIView {

    public enum LayoutAxis {
        case vertical(maxWidth: CGFloat)
        case horizontal(maxHeight: CGFloat)
    }

    /// 超出文字部分的扩展方向  vertical 为纵向, horizontal 为 横向
    public var axis: LayoutAxis = .vertical(maxWidth: CGFloat.screenWidth)

    /// 内部使用scrollView
    var contentView: UIScrollView = UIScrollView()

    public var label: CICLabel = CICLabel()

    public convenience init(_ frame: CGRect, axis: LayoutAxis) {
        self.init(frame: frame)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
        contentView.addSubview(label)
        label.text("")
            .line(0)
            .font(CIComponentKitThemeCurrentConfig.defaultFont)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func layout() {
        contentView.frame = self.bounds

        label.x(0).y(0)
        switch axis {
        case .horizontal(let maxHeight):
            label.height(maxHeight).sizeToFit()
            contentView.contentSize = CGSize.init(width: label.cic.width, height: 0)
        case .vertical(let maxWidth):
            label.width(maxWidth).sizeToFit()
            contentView.contentSize = CGSize.init(width: 0, height: label.cic.height)
        }
    }

    // adjust size
    public override func layoutSubviews() {
        super.layoutSubviews()

        layout()
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        switch axis {
        case .horizontal(_):
            label.height(size.height).sizeTo(layout: .maxHeight(size.height))
        case .vertical(_):
            label.width(size.width).sizeTo(layout: .maxWidth(size.width))
        }

        return label.bounds.size
    }
}
