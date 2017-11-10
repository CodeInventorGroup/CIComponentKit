//
//  UIViewController+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit

public extension CIComponentKit where Base: UIViewController {

    var visibleViewController: UIViewController? {
        
        if let presentVC = base.presentedViewController {
            return presentVC.cic.visibleViewController
        }
        
        if let base = base as? UITabBarController {
            return base.selectedViewController?.cic.visibleViewController
        } else if let base = base as? UINavigationController {
            return base.visibleViewController?.cic.visibleViewController
        }
        if base.isViewLoaded && (base.view.window != nil) {
            return base
        } else {
            print("UIViewController \(base)")
        }
        return nil
    }
}

public extension UIViewController {
    struct cic {
        public static var appearance: CICUIViewController {
            return CICUIViewController()
        }
    }
}

public enum ControllerState<T> {
    case loading
    case loaded(data: T)
    case error(message: String)
}

public protocol CICViewControllerStateProtocol {
    associatedtype DataModel
    var state: ControllerState<DataModel> {get set}
    var loadingView: UIView { get }
    var errorView: UIView { get }
    
    func stateDidChanged()
}

extension CICViewControllerStateProtocol where Self: CICUIViewController {
//    public typealias DataModel = String
}

open class CICUIViewController: UIViewController, CICAppearance {
    
    public var loadingView = UIView()
    public var errorView = UIView()
    public var state: ControllerState<String> = .loading {
        didSet {
            stateDidChanged()
        }
    }

    public func stateDidChanged() {
        switch state {
        case .loading:
            print("正在加载")
        case .loaded(let str):
            print("data loaded: \(str)")
        case .error(let errorMessage):
            print("data loaded error: \(errorMessage)")
        }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.willToggleTheme),
                                               name: NSNotification.Name.cic.themeWillToggle,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CICAppearance.didToggleTheme),
                                               name: NSNotification.Name.cic.themeWillToggle,
                                               object: nil)
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 主题支持
    open func willToggleTheme() {
        print("CICUIViewController willToggleTheme")
    }

    open func didToggleTheme() {
        print("CICUIViewController didToggleTheme")
    }

    // MARK: - 屏幕旋转
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: -
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
