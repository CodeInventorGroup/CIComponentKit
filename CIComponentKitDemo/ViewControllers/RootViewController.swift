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

enum CardActions: Int {
    case Alert = 0
    case CICLabel = 1
    case Loading = 2
    case Notifier = 3
    case Guide = 4
    case NetworkStatus = 5
    case ActivityView = 6
}

class RootViewController: CICUIViewController {
    
    private let scrollView = UIScrollView(frame: .zero)
    
    private let cardScrollView = UIScrollView(frame: .zero)
    
    let cardDatas = [("Alert", "CICHUD.showAlert"),
                     ("CICLabel", "UILabel.cic.appearance"),
                     ("Loaing", "CICHUD.show"),
                     ("Notifier", "CICHUD.showNotifier"),
                     ("Guide", "CICHUD.showGuide"),
                     ("NetworkStatus", "CICHUD.showNetworkStaus"),
                     ("ActivityView", "CICHUD.showActivityView")]
    let animationColors = [
                           UIColor.flat.orange,
                           UIColor.flat.blue,
                           UIColor.flat.grey,
                           UIColor.flat.base,
                           UIColor.flat.extraDark,
                           UIColor.flat.black,
                           UIColor.flat.green
                           ]
    private var cachedFeedLayout: Layout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CIComponentKit"
        self.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {

        }
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        view.addSubview(scrollView)
        
        layout()
    }
    
    func layout(_ size: CGSize = .screenSize) {
        scrollView.size(size)
        let arrangement = self.getLayout(size.width).arrangement(width: size.width)
        DispatchQueue.main.async {
            self.scrollView.contentSize = arrangement.frame.size
            arrangement.makeViews(in: self.scrollView)
        }
    }
        
    func getLayout(_ width: CGFloat) -> Layout {
        
        if let cachedFeedLayout = cachedFeedLayout {
            return cachedFeedLayout
        }
        
        var cardItems = [Layout]()
        for (index, (title, subtitle)) in self.cardDatas.enumerated() {
            let size = CGSize.init(width: width - 40, height: 500)
            let rootCarLayout = RootCardLayout.init(title,
                                                    subtitle: subtitle,
                                                    info: String.LoremIpsum,
                                                    size: size,
                                                    action: {
                self.cardActionClicked(index)
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
    

    // card的点击事件
    func cardActionClicked(_ index: Int) {
        guard let cardAction = CardActions.init(rawValue: index) else {
            CICHUD.toast("CardAction 寻找失败", blurStyle: .extraLight)
            return
        }
        switch cardAction {
        case .Alert:
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
                CICHUD.showNotifier(title: "CICScrollLabel  /  CICButton")
                let scrollLabel = CICScrollLabel.init(CGRect(x: 0, y: 200, width: .screenWidth, height: 100),
                                                      axis: .vertical(maxWidth: .screenWidth))
                scrollLabel.label.text(tips).textColor(UIColor.flat.white)
                scrollLabel.backgroundColor(.black)
                    .layout()
                self.view.addSubview(scrollLabel)

                let btn = CICButton().frame(CGRect(x: 100, y: 300, width: 200, height: 44))
                    .backgroundColor(.red)
                btn.setAttributedTitle(NSAttributedString.init(string: "manoboo_normal", attributes: [.font: UIFont.systemFont(ofSize: 20.0), .foregroundColor: UIColor.white]), for: .normal)
                btn.setAttributedTitle(NSAttributedString.init(string: "manoboo_selected", attributes: [.font: UIFont.systemFont(ofSize: 12.0), .foregroundColor: UIColor.green]), for: .selected)
                btn.setImage(#imageLiteral(resourceName: "item1-selected"), for: .normal)
                btn.setImage(#imageLiteral(resourceName: "item1-selected"), for: .selected)
                btn.imageInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
                btn.titleInsets = UIEdgeInsets.init(top: 50, left: 10, bottom: 50, right: 10)
                btn.currentLayout = .leftImage
                self.view.addSubview(btn)
                btn.sizeToFit()
                btn.addHandler(for: .touchUpInside, handler: { (ctrl) in
                    print(ctrl)
                    print("click cicbutton~")
                    btn.state = (btn.isSelected) ? .normal : .selected
                    UIView.animate(withDuration: 0.35, animations: {
                        btn.sizeToFit()
                    })
                })
            })
            break
        case .CICLabel:
            CICHUD.toast("长按下方文字进行复制", blurStyle: .extraLight)
            break
        case .Loading:
            CICHUD.show("正在加载~", blurStyle: .extraLight)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                CICHUD.hide()
            })
            break
        case .Notifier:
            CICHUD.showNotifier(title: "我一点都不嫉妒~")
            break
        case .Guide:
            CICHUD.showGuide(.poemTitle, message: .poem, animated: true)
            break
        case .NetworkStatus:
            CICHUD.showNetWorkStatusChange("失去网络连接")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                CICHUD.hideNetWorkStatusChange()
            })
            break
        default:
            CICHUD.showActivityView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                CICHUD.hideActivityView()
            })
            break
        }
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
        theme.config.defaultFont = UIFont.systemFont(ofSize: CGFloat(arc4random_uniform(15)) + 5.0)
        theme.config.textColor = UIColor.cic.random
        theme.config.mainColor = UIColor.cic.hex(hex: 0xFAFAFA)
        theme.config.tintColor = UIColor.cic.hex(hex: 0xDF312E)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.random
        theme.config.navigationBarBackgroundColor = UIColor.flat.orange
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

//        let alertViewController = UIAlertController.init(title: "asdasds", message: "asdasdas\nasdasdas\nasdas", preferredStyle: .alert)
//        alertViewController.addAction(UIAlertAction.init(title: "hehehe", style: .default, handler: nil))
//        alertViewController.addAction(UIAlertAction.init(title: "hehehe1", style: .cancel, handler: nil))
//        alertViewController.addAction(UIAlertAction.init(title: "hehehe2", style: .destructive, handler: nil))
//        self.present(alertViewController, animated: true, completion: nil)
//        return

        
        let alertView = CICAlertView.init(contentView: nil,
                                          title: String.poemTitle,
                                          content: String.funnyTip + String.poem)
        let action1 = CICAlertAction.init("喜欢ManoBoo") { (_) in
            print("action1")
        }
        let action2 = CICAlertAction.init("喜欢ZRFlower") { (_) in
            print("action2")
        }
        let action3 = CICAlertAction.init("站在此地别走动") { (_) in
            print("action3")
        }
        let action4 = CICAlertAction.init("我去给你买颗橘子树") { (_) in
            print("action4")
        }
        alertView.addAction(action1, action2, action3, action4)
        alertView.show()

        state = .loaded(data: "加载数据咯 - \(index)")
    }
}
