//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/31.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit


/********************************************* this is a demo ******************************
 
 let label = UILabel.cic.appearance
 label.text = "welcome to cicomponentkti~ O(∩_∩)O~~"
 self.view.addSubview(label)
 
 ********************************************* this is a demo ******************************/



// 为了让用户用最少的修改即可动态换主题，又减少操作，采取了折中方法
public extension UILabel {
    struct cic {
        public static var appearance: CICLabel {
            return CICLabel()
        }
    }
}

// 为调用了 ci.appearance 方法的UILabel实例 添加 CIComponentAppearance 协议支持
extension CICLabel: CICAppearance {
    
    public func didToggleTheme() {
        if self.textColor != CIComponentKitThemeCurrentConfig.textColor {
            self.textColor = CIComponentKitThemeCurrentConfig.textColor
        }
        if self.font != CIComponentKitThemeCurrentConfig.defaultFont {
            self.font = CIComponentKitThemeCurrentConfig.defaultFont
        }
    }
    
    public func willToggleTheme() {
        
    }
}


/********************************************* CILabel ******************************/
/// CILabel 自定义UILabel,支持 长按复制
public class CICLabel: UILabel {
    
    private var tempBackgroundColor: UIColor?
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let g = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPressEvent(_:)))
        self.addGestureRecognizer(g)
        return g
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initMethod()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initMethod() -> Swift.Void {
        // receive the notification of togglling theme
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.willToggleTheme), name: Notification.Name.cic.themeWillToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.didToggleTheme), name: Notification.Name.cic.themeDidToggle, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func drawText(in rect: CGRect) {
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, contentEdgeInset))
    }
    
    //MARK: - 扩展属性
    
        // - 文字距离上下左右的边距
    public var contentEdgeInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
        // - 提供长按操作时的高亮背景颜色
    public var highlightedBackgroundColor: UIColor = CIComponentKitThemeCurrentConfig.highlightedBackgroundColor {
        didSet {
            tempBackgroundColor = backgroundColor
        }
    }
    
    override public var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            backgroundColor = isHighlighted ? highlightedBackgroundColor : tempBackgroundColor
        }
    }
    
    public override var canBecomeFirstResponder: Bool {
        return longPressAction == .copy
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if longPressAction == .copy {
            return action == #selector(copyEvent)
        }
        return false
    }
    
    /// - CICLabel长按的type
    public enum LongPressAction {
        case none
        case copy
        case Touch3D // building
    }
    
        // - copy完成之后的回调
    public var copySuccessClousure: (() -> ())?

        // - 长按操作
    public var longPressAction: LongPressAction = .none {
        didSet {
            if longPressAction == .copy {
                isUserInteractionEnabled = true
                longPressGesture.isEnabled = true
                NotificationCenter.default.addObserver(self, selector: #selector(handleMenuHideEvent(_:)), name: .UIMenuControllerWillHideMenu, object: nil)
                
            }else {
                self.isUserInteractionEnabled = false
                longPressGesture.isEnabled = false
                NotificationCenter.default.removeObserver(self, name: .UIMenuControllerWillHideMenu, object: nil)
            }
        }
    }
    
        // - longPressAction == .copy 时,copy的范围
    public var copyRange: NSRange? = nil
    
    override public var text: String? {
        didSet {
            super.text = text
            if let lengh = text?.characters.count,copyRange == nil {
                // 默认copy整个字符串
                copyRange = NSMakeRange(0, lengh)
            }
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            super.attributedText = attributedText
            if let length = attributedText?.string.characters.count, copyRange == nil {
                copyRange = NSMakeRange(0, length)
            }
        }
    }
    
    //MARK: - Event
    
    func copyEvent() -> Swift.Void {
        guard let string = (self.attributedText?.string ?? self.text), string.isEmpty == false else{
            print("\(self) copy text should not be nil ")
            return
        }
        if let copyRange = copyRange {
            let str = ((string as NSString).substring(with: copyRange)) as String
            UIPasteboard.general.string = str
            if copySuccessClousure != nil {
                copySuccessClousure!()
            }
        }
    }
    
    func handleLongPressEvent(_ longPressGesture: UILongPressGestureRecognizer) -> Swift.Void {
        if longPressAction != .copy {
            return
        }
        if longPressGesture.state == .began {
            self.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.menuItems = [UIMenuItem.init(title: "复制", action: #selector(copyEvent))]
            menuController.setTargetRect(self.frame, in: self.superview!)
            menuController.setMenuVisible(true, animated: true)
            
            tempBackgroundColor = backgroundColor
            isHighlighted = true
        }
    }
    
    func handleMenuHideEvent(_ notifier: NSNotification) -> Swift.Void {
        if longPressAction != .copy {
            return
        }
        if isHighlighted {
            isHighlighted = false
        }
    }
}


// MARK: - CILabel
extension CICLabel {
    
    @discardableResult
    public func contentEdgeInset(_ contentEdgeInset: UIEdgeInsets = .zero) -> Self {
        self.contentEdgeInset = contentEdgeInset
        return self
    }
    
    @discardableResult
    public func longPressAction(_ longPressAction: LongPressAction = .none) -> Self {
        self.longPressAction = longPressAction
        return self
    }
    
    @discardableResult
    public func highlightedBackgroundColor(_ highlightedBackgroundColor: UIColor = CIComponentKitThemeCurrentConfig.highlightedBackgroundColor) -> Self {
        self.highlightedBackgroundColor = highlightedBackgroundColor
        return self
    }
    
    @discardableResult
    public func copyRange(_ copyRange: NSRange) -> Self {
        self.copyRange = copyRange
        return self
    }
}

