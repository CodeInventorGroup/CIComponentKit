//
//  UILabel+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/31.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit


/********************************************* this is a demo ******************************
 
 let label = UILabel.ci.appearance
 label.text = "welcome to cicomponentkti~ O(∩_∩)O~~"
 self.view.addSubview(label)
 
 ********************************************* this is a demo ******************************/



// 为了让用户用最少的修改即可动态换主题，又减少操作，采取了折中方法
public extension UILabel {
    struct ci {
        public static var appearance: CILabel {
            return CILabel()
        }
    }
}

// 为调用了 ci.appearance 方法的UILabel实例 添加 CIComponentAppearance 协议支持
extension CILabel: CICAppearance {
    
    func didToggleTheme() {
        if self.textColor != CIComponentKitThemeCurrentConfig.textColor {
            self.textColor = CIComponentKitThemeCurrentConfig.textColor
        }
        if self.font != CIComponentKitThemeCurrentConfig.defaultFont {
            self.font = CIComponentKitThemeCurrentConfig.defaultFont
        }
    }
    
    func willToggleTheme() {
        
    }
}


/********************************************* CILabel begin ******************************/
/// CILabel 自定义UILabel,支持 长按复制
public class CILabel: UILabel {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.willToggleTheme), name: Notification.Name.ci.themeWillToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CICAppearance.didToggleTheme), name: Notification.Name.ci.themeDidToggle, object: nil)
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
    
    
    private var tempBackgroundColor: UIColor?
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let g = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPressEvent(_:)))
        self.addGestureRecognizer(g)
        return g
    }()
        // - 提供长按操作时的高亮背景颜色
    public var highlightedBackgroundColor: UIColor = CIComponentKitThemeCurrentConfig.highlightedBackgroundColor {
        didSet {
            tempBackgroundColor = backgroundColor
        }
    }
    
    
    public override var isHighlighted: Bool {
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
    
    public enum LongPressAction {
        case none
        case copy
        case Touch3D // building
    }

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
    
    //MARK: - Event
    
    func copyEvent() -> Swift.Void {
        if (self.text != nil) {
            let board = UIPasteboard.general
            board.string = self.text
        }
    }
    
    func handleLongPressEvent(_ longPressGesture: UILongPressGestureRecognizer) -> Swift.Void {
        if longPressAction != .copy {
            return
        }
        if longPressGesture.state == .began {
            print(self.becomeFirstResponder())
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

/********************************************* CILabel end ******************************/



/********************************************* extension UILabel begin ******************************/


extension UILabel {
    
    // numberOfLines
    @discardableResult
    public func line(_ lineNumbers: Int = 0) -> Self {
        self.numberOfLines = lineNumbers
        return self
    }
    
    // text
    @discardableResult
    public func text(_ string : String? = nil) -> Self {
        self.text = string
        return self
    }
    
    // font
    @discardableResult
    public func font(_ font : UIFont = UIFont.ci.systemFont) -> Self {
        self.font = font
        return self
    }
    
    // textColor
    @discardableResult
    public func textColor(_ color: UIColor = CIComponentKitThemeCurrentConfig.textColor) -> Self {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func textAlignment(_ textAlignment: NSTextAlignment = .left) -> Self {
        self.textAlignment = textAlignment
        return self
    }
    
}

/********************************************* extension UILabel end ******************************/
