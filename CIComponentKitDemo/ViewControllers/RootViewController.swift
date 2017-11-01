//
//  RootViewController.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/10/26.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

import CIComponentKit
import LayoutKit

class RootViewController: UIViewController {
    
    private let scrollView = UIScrollView(frame: .zero)
    
    private let cardScrollView = UIScrollView(frame: .zero)
    
    let cardDatas = [("弹窗HUD", "CICHUD"), ("CICLabel", "自定义Label"), ("弹窗HUD", "CICHUD"), ("弹窗HUD", "CICHUD")]
    let animationColors = [UIColor.flat.orange,
                           UIColor.flat.blue,
                           UIColor.flat.grey,
                           UIColor.flat.base
                           ]
    private var cachedFeedLayout: Layout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CIComponentKit"
        self.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        // Do any additional setup after loading the view, typically from a nib.
        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        edgesForExtendedLayout = []
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(scrollView)
        
        layout()
    }
    
    func layout(_ size: CGSize = .screenSize) {
        scrollView.size(size)
        let start = CFAbsoluteTimeGetCurrent()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let arrangement = self.getLayout(size.width).arrangement(width: size.width)
            DispatchQueue.main.async {
                var size = arrangement.frame.size
                size.height += 64
                self.scrollView.contentSize = size
                arrangement.makeViews(in: self.scrollView)
                let end = CFAbsoluteTimeGetCurrent()
                print(" layout time: \(end - start).ms")
            }
        }
        
    }
        
    func getLayout(_ width: CGFloat) -> Layout {
        
        if let cachedFeedLayout = cachedFeedLayout {
            return cachedFeedLayout
        }
        
        var cardItems = [Layout]()
        for (index, (title, subtitle)) in self.cardDatas.enumerated() {
            let size = CGSize.init(width: width - 40, height: 500)
            let rootCarLayout = RootCardLayout.init(title, subtitle: subtitle, info: String.LoremIpsum, size: size, action: {
                print("\(index) card has been clicked")
            })
            cardItems.append(rootCarLayout)
        }
        
        let cards = InsetLayout.init(insets: UIEdgeInsetsMake(20, 20, 20, 20),
                                           sublayout: StackLayout(
                                            axis: .horizontal,
                                            spacing: 40,
                                            distribution: .leading,
                                            sublayouts: cardItems
                                           )
        )
        
        let cardsArrangement = cards.arrangement()
        
        let cardsLayout = SizeLayout<UIScrollView>.init(width: width,
                                      height: cardsArrangement.frame.height,
                                      sublayout: nil
                                      ) { (cardView) in
                                        DispatchQueue.main.async {
                                            cardsArrangement.makeViews(in: cardView)
                                            cardView.isPagingEnabled = true
                                            cardView.delegate = self
                                            cardView.contentSize = CGSize(width: cardsArrangement.frame.width, height: 0)
                                        }
        }
        
        
        let toggleButtonLayout = SizeLayout<UIButton>.init(width: width, height: 64) { (toggle) in
            toggle.backgroundColor(UIColor.cic.hex(hex: 0x06e2c9))
                .setTitle("Toggle theme", for: .normal)
            toggle.addHandler(for: .touchUpInside, handler: { (_) in
                self.changeTheme()
            })
        }
        
        let jumpButtonLayout = SizeLayout<UIButton>.init(width: width, height: 64) { (jump) in
            jump.backgroundColor(UIColor.cic.hex(hex: 0x22a9e8))
                .setTitle("JUMP TO CICUIViewController", for: .normal)
            jump.addHandler(for: .touchUpInside, handler: { (_) in
                self.jump()
            })
        }
        
        let stackLayout = StackLayout<UIView>.init(axis: Axis.vertical,
                                                   spacing: 70.0,
                                                   sublayouts: [cardsLayout, toggleButtonLayout, jumpButtonLayout]) { (_) in
            
        }
        
//        cachedFeedLayout = stackLayout
        return stackLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        CICHUD.show("正在加载~", blurStyle: .extraLight, layoutStyle: .right)
//        CICHUD.showActivityView()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            CICHUD.hideActivityView()
//        }
        
        
        let title = """
                        ManoBoo & NEWWORLD
                        新的开源组件库,你喜欢吗😄😄😄
                        哈哈,这是一段测试文字
                    """
        let message = """
                        假如生活欺骗了你
                        不要悲伤，不要心急！
                        忧郁的日子里需要镇静：
                        相信吧，快乐的日子将会来临。
                        心儿永远向往着未来，
                        现在却常是忧郁；
                        一切都是瞬息，
                        一切都将会过去，
                        而那过去了的，
                        就会成为亲切的回忆。
                    """
//        CICHUD.showGuide(title, message: message, animated: true)
        
//        CICHUD.showNotifier(title: "哈哈 manoboo爱你哟~")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        CICHUD.default.hide()
        CICHUD.hideNetWorkStatusChange()
    }
    
    @objc func jump() -> Swift.Void {
        let vc = SecondViewController()
        vc.title = "CICUIViewController"
        vc.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeTheme() -> Swift.Void {
        
        let theme = CIComponentKitTheme.originTheme
        theme.config.textColor = UIColor.cic.random
        theme.config.mainColor = UIColor.cic.hex(hex: 0xFAFAFA)
        theme.config.tintColor = UIColor.cic.hex(hex: 0xDF312E)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.random
        theme.config.navigationBarBackgroundColor = UIColor.cic.random
        theme.config.alertMessageColor = UIColor.cic.random
        theme.renderTheme()
    }
}

extension RootViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layout(size)
    }
}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x / CGFloat.screenWidth)
        UIView.animate(withDuration: 0.5) {
            self.scrollView.backgroundColor(self.animationColors[index])
        }
    }
}




