//
//  RootViewController.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/10/26.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

import CIComponentKit

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

    private let tableView = UITableView.init(frame: .zero, style: .grouped)

    let data = [(title: "CICAlertView", subtitle: "CICHUD.showAlert", info: "与系统的UIAlertController调用方式基本一致"),
                (title: "CICLabel", subtitle: "UILabel.cic.appearance", info: "一个自定义Label, 长按可以复制文本, 可以设置内外边距"),
                (title: "Loaing", subtitle: "CICHUD.show", info: "加载框"),
                (title: "Notifier", subtitle: "Notifier", info: "顶部通知栏, 可自定义颜色/图片/文本"),
                (title: "Guide", subtitle: "CICHUD.showGuide", info: "底部弹出一个引导或提示窗体"),
                (title: "NetworkStatus", subtitle: "CICHUD.showNetworkStaus", info: "网络连接提示窗体"),
                (title: "ActivityView", subtitle: "CICHUD.showActivityView", info: "Apple 设计软件中常用的Loading框")]
    let animationColors = [
                           UIColor.flat.orange,
                           UIColor.flat.blue,
                           UIColor.flat.grey,
                           UIColor.flat.base,
                           UIColor.flat.extraDark,
                           UIColor.flat.black,
                           UIColor.flat.green
                           ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CIComponentKit"
        self.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame(view.bounds)
        tableView.register(RootTableViewCell.self, forCellReuseIdentifier: "RootTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 44.0
        tableView.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame(view.bounds)
        tableView.reloadData()
    }

    override func didToggleTheme() {
        super.didToggleTheme()
        DispatchQueue.main.async {
            self.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
            self.tableView.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        }
    }

    func scrollLabelOrCustomButton() {
        CICHUD.showNotifier(title: "CICScrollLabel  /  CICButton")
        let scrollLabel = CICScrollLabel.init(CGRect(x: 0, y: 200, width: .screenWidth, height: 100),
                                              axis: .vertical(maxWidth: .screenWidth))
        scrollLabel.label.text(String.funnyTip).textColor(UIColor.flat.white)
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

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RootTableViewCell") as! RootTableViewCell
        if let cellData = data.safeElement(at: indexPath.section) {
            cell.data = cellData
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cardAction = CardActions.init(rawValue: indexPath.section) else {
            CICHUD.toast("未找到动作", blurStyle: .extraLight)
            return
        }
        switch cardAction {
        case .Alert:
            let alertView = CICAlertView.init(contentView: nil,
                                              title: "羡慕使我嫉妒",
                                              content: String.funnyTip)
            let action1 = CICAlertAction.init("ManoBoo") { (_) in
                CICHUD.showNotifier(.error, title: "爱酱今天要元气满满哦~")
            }
            let action2 = CICAlertAction.init("ZRFlower") { (_) in
                CICHUD.showNotifier(.success, title: "ZRFlower")
            }
            let action3 = CICAlertAction.init("站在此地别走动") { (_) in
                CICHUD.showNotifier(.status, title: "站在此地别走动")
            }
            let action4 = CICAlertAction.init("我去给你买颗橘子树") { (_) in
                CICHUD.showNotifier(.warning, title: "我去给你买颗橘子树")
            }
            let action5 = CICAlertAction.init("一些自定义控件", configure: { $0.textColor(UIColor.flat.orange) }) { (_) in
                self.scrollLabelOrCustomButton()
            }
            
            _ = [action1, action2, action3, action4, action5].map { $0.backgroundColor(UIColor.cic.hex(hex: 0x1B1C1E)) }
            alertView.addAction(action1, action2, action3, action4, action5)
            alertView.show()
            break
        case .CICLabel:
            CICHUD.toast("长按下方文字进行复制长按下方文字进行复制长按下方文字进行复制", blurStyle: .extraLight)
            break
        case .Loading:
            CICHUD.show("小二正在拼命加载", blurStyle: .extraLight)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                CICHUD.hide()
            })
            break
        case .Notifier:
            CICHUD.showNotifier(title: "不要998，不要98，现在只要购买只要￥9.8，你还在犹豫什么？")
            break
        case .Guide:
            CICHUD.showGuide(.poemTitle, message: .poem, animated: true)
            break
        case .NetworkStatus:
            CICHUD.showNetWorkStatusChange("您已失去网络连接")
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
}

