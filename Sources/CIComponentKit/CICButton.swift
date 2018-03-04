//
//  CICButton.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/11/22.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  UIControl自定义Button,添加多种状态支持

import UIKit

/// CICButton的状态
///
/// - normal: 正常状态
/// - selected: 选中
/// - highlighted: 高亮
/// - disabled: 不可用
/// - loading: 加载中(常见于网络请求)
//public enum CICButtonState: Int {
//    case normal = 0
//
//    case selected
//
//    case highlighted
//
//    case disabled
//
//    case loading
//}

//UIControlState
public struct CICButtonState: OptionSet, Hashable {
    
    public static let normal = CICButtonState.init(rawValue: 1)
    public static let selected = CICButtonState.init(rawValue: 2)
    public static let highlighted = CICButtonState.init(rawValue: 4)
    public static let disabled = CICButtonState.init(rawValue: 8)
    public static let loading = CICButtonState.init(rawValue: 32)
    
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public var hashValue: Int {
        return rawValue.hashValue
    }
    public static func == (lhs: CICButtonState, rhs: CICButtonState) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

/// 默认提供的image title布局位置
public enum CICButtonLayout {
    case leftImage   //  rightTitle
    case topImage    //  bottomTitle
    case bottomImage //  topTitle
    case rightImage  //  leftTitle
}

/// CICButton style
public struct CICButtonStyle {
    var title: String?
    var titleColor: UIColor?
    var titleShadowColor: UIColor?
    var font: UIFont?
    var image: UIImage?
    var backgroundImage: UIImage?
    var attributeString: NSAttributedString?
}

public class CICButton: CICUIView {

    open var state: CICButtonState = .normal {
        didSet {
            renderState()
        }
    }

    /// 是否被选中
    open var isSelected: Bool {
        return state == .selected
    }

    /// 返回当前的样式及标题等
    open var currentStyle: CICButtonStyle? {
        return stateMapStyle[state]
    }

    /// 默认图片在左边
    open var currentLayout: CICButtonLayout = .leftImage
    open var titleInsets: UIEdgeInsets = .zero
    open var imageInsets: UIEdgeInsets = .zero

    /// 布局, 默认为nil, 若使用该自定义布局, `currentLayout` 将无效
    open var layoutMaker: ((CICButton) -> Void)?

    /// 加载中点击按钮是否响应
    var isEnabledWhenLoading = false

    typealias CICButtonHandler = ((CICButton) -> Void)
    private var stateMapStyle = [CICButtonState: CICButtonStyle]()

    var control: UIControl = UIControl()
    var backgroundImageView = UIImageView()
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var activityView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)

    init() {
        super.init(frame: .zero)
        initSubviews()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initSubviews() {
        addSubview(backgroundImageView)
        addSubview(imageView)
        titleLabel.textColor(UIButton.appearance().tintColor ?? .black)
            .font(UIFont.cic.systemFont)
        addSubview(titleLabel)
        activityView.isHidden = true
        addSubview(activityView)
        addSubview(control)
        stateMapStyle = [.normal: CICButtonStyle(),
                         .selected: CICButtonStyle(),
                         .highlighted: CICButtonStyle(),
                         .disabled: CICButtonStyle(),
                         .loading: CICButtonStyle()]
    }

    func render() {
        renderState()
        if let layoutMaker = layoutMaker {
            layoutMaker(self)
        } else {
            // 展开默认布局
            imageView.sizeToFit()
            titleLabel.sizeToFit()
            switch currentLayout {
            case .leftImage:
                imageView.x(imageInsets.left).y(imageInsets.top)
                titleLabel.x(imageView.cic.right + titleInsets.left).y(titleInsets.top)
            case .rightImage:
                titleLabel.x(titleInsets.left).y(titleInsets.top)
                imageView.x(titleLabel.cic.right + imageInsets.left).y(imageInsets.top)
            case .topImage:
                imageView.y(imageInsets.top)
                titleLabel.y(imageView.cic.bottom + imageInsets.bottom + titleInsets.top)
            case .bottomImage:
                titleLabel.y(titleInsets.top)
                imageView.y(titleLabel.cic.bottom + titleInsets.bottom)
            }
        }
    }

    func renderState() {
        guard let style = stateMapStyle[state] else {
            return
        }
        backgroundImageView.image = style.backgroundImage
        imageView.image = style.image
        if let attributeString = style.attributeString {
            titleLabel.attributedText = attributeString
        } else {
            titleLabel.text(style.title)
                .textColor(style.titleColor ?? .black)
                .font(style.font ?? UIFont.cic.systemFont)
        }
        if state == .loading {
            activityView.startAnimating()
        }
        activityView.isHidden = !(state == .loading)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)

        render()

        var fitSize = size
        switch currentLayout {
        case .leftImage, .rightImage:
            fitSize.width = CGFloat.maximum(titleLabel.cic.right + titleInsets.right,
                                            imageView.cic.right + imageInsets.right)
            fitSize.height = CGFloat.maximum(titleLabel.cic.bottom + titleInsets.bottom,
                                             imageView.cic.bottom + imageInsets.bottom)
            titleLabel.centerY(fitSize.height / 2.0)
            imageView.centerY(fitSize.height / 2.0)
        case .topImage, .bottomImage:
            fitSize.height = CGFloat.maximum(titleLabel.cic.bottom + titleInsets.bottom,
                                             imageView.cic.bottom + imageInsets.bottom)
            fitSize.width = CGFloat.maximum(titleLabel.cic.right + titleInsets.right,
                                            imageView.cic.right + imageInsets.right)
            titleLabel.centerX(fitSize.width / 2.0)
            imageView.centerX(fitSize.width / 2.0)
        }
        return fitSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        control.frame(self.bounds)
        renderState()
        if let layoutMaker = layoutMaker {
            layoutMaker(self)
        }
    }
}

// MARK: - add CICButtonState support
extension CICButton {

    public func setTitle(_ title: String = "", for state: CICButtonState) {
        stateMapStyle[state]?.title = title
    }

    public func setTitleColor(_ color: UIColor?, for state: CICButtonState) {
        stateMapStyle[state]?.titleColor = color
    }

    public func setTitleShadowColor(_ color: UIColor?, for state: CICButtonState) {
        stateMapStyle[state]?.titleShadowColor = color
    }

    public func setImage(_ image: UIImage?, for state: CICButtonState) {
        stateMapStyle[state]?.image = image
    }

    public func setBackgroundImage(_ image: UIImage?, for state: CICButtonState) {
        stateMapStyle[state]?.backgroundImage = image
    }

    @available(iOS 6.0, *)
    public func setAttributedTitle(_ title: NSAttributedString?, for state: CICButtonState) {
        stateMapStyle[state]?.attributeString = title
    }

    public func title(for state: CICButtonState) -> String? {
        return stateMapStyle[state]?.title
    }

    public func titleColor(for state: CICButtonState) -> UIColor? {
        return stateMapStyle[state]?.titleColor
    }

    public func titleShadowColor(for state: CICButtonState) -> UIColor? {
        return stateMapStyle[state]?.titleShadowColor
    }

    public func image(for state: CICButtonState) -> UIImage? {
        return stateMapStyle[state]?.image
    }

    public func backgroundImage(for state: CICButtonState) -> UIImage? {
        return stateMapStyle[state]?.backgroundImage
    }

    @available(iOS 6.0, *)
    public func attributedTitle(for state: CICButtonState) -> NSAttributedString? {
        return stateMapStyle[state]?.attributeString
    }
}

extension CICButton {
    public func addHandler(for event: UIControlEvents, handler: @escaping ((UIControl) -> Void)) {
        control.addHandler(for: event, handler: handler)
    }
}
