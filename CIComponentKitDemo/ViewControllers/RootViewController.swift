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
    
    let scrollView = UIScrollView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CIComponentKit"
        self.view.backgroundColor(.white)
        // Do any additional setup after loading the view, typically from a nib.
        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        edgesForExtendedLayout = []
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        initSubviews()
        
//        let label = UILabel.cic.appearance
//        label.y(64)
//            .width(CGFloat.screenWidth).height(100)
//            .line(0)
//            .text(String.LoremIpsum)
//            .font(UIFont.preferredFont(forTextStyle: .body))
//            .textAlignment(.center)
//            .textColor(CIComponentKitThemeCurrentConfig.textColor)
//            .backgroundColor(UIColor.cic.hex(hex:  0xf2f2f2))
//            .longPressAction(.copy)
//            .copyRange(NSMakeRange(0, 5))
//        label.copySuccessClousure = {
//            CICHUD.showNetWorkStatusChange()
//            CICHUD.showAlert(content: "主题更换成功")
//        }
//        self.view.addSubview(label)
        
        let toggleThemeBtn = UIButton()
        toggleThemeBtn.height(64)
            .bottom(0, view: view)
            .width(view)
            .backgroundColor(UIColor.cic.hex(hex: 0x06e2c9))
        toggleThemeBtn.titleLabel?.font(UIFont.cic.preferred(.body))
        toggleThemeBtn.setTitle("Toggle theme", for: .normal)
        toggleThemeBtn.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        view.addSubview(toggleThemeBtn)

        let jumpBtn = UIButton()
        jumpBtn
            .y(toggleThemeBtn.frame.minY - 64)
            .height(64)
            .width(view)
            .backgroundColor(UIColor.cic.hex(hex: 0x22a9e8))
        jumpBtn.titleLabel?.font(UIFont.cic.preferred(.headline))
        jumpBtn.setTitle("JUMP TO CICUIViewController", for: .normal)
        jumpBtn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        view.addSubview(jumpBtn)
        
    }
    
    func initSubviews() {
        scrollView.y(0).width(view).height(.screenHeight * 0.5)
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        let dataFields = [("弹窗HUD", "CICHUD"), ("CICLabel", "自定义Label"), ("弹窗HUD", "CICHUD")]
//        for (index, (title, subtitle)) in dataFields.enumerated() {
//            let originX = CGFloat(index) * CGFloat.screenWidth + 20
//            let card = RootCard.init(title, subtitle: subtitle)
//                .frame(CGRect(x: originX, y: 10, width: scrollView.cic.width - 40, height: scrollView.cic.height - 20))
//            scrollView.addSubview(card)
//        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            var cardItems = [Layout]()
            for (_, (title, subtitle)) in dataFields.enumerated() {
                let viewReuseId = String.cic.random(10)
                let size = CGSize.init(width: .screenWidth - 40, height: self.scrollView.cic.height)
                print("viewReuseId: \(viewReuseId)")
                let rootCarLayout = RootCardLayout.init(title, subtitle: subtitle, info: String.LoremIpsum, size: size, action: {
                    print("....")
                })

                cardItems.append(rootCarLayout)
            }
            
            
            let feedLayout =  InsetLayout.init(insets: UIEdgeInsetsMake(0, 20, 0, 20),
                                               sublayout: StackLayout(
                                                    axis: .horizontal,
                                                    spacing: 40,
                                                    distribution: .leading,
                                                    sublayouts: cardItems
                                                )
            )
            let arrangement = feedLayout.arrangement(height: self.scrollView.cic.height)
            DispatchQueue.main.async {
                self.scrollView.contentSize = arrangement.frame.size
                arrangement.makeViews(in: self.scrollView)
            }
        }
        
        scrollView.delegate = self
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

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / CGFloat.screenWidth
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor(UIColor.cic.random)
        }
    }
}




