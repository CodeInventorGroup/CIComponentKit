//
//  ViewController.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit
import CIComponentKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for index in 0...3 {
            
            let label = UILabel.ci.appearance
            label.longPressAction = .copy
            let rect = CGRect.init(x: 0, y: 100 + 66 * CGFloat(index), width: view.bounds.width, height: 200)
            label.frame(rect)
                .line()
                .text(String.LoremIpsum)
                .font(UIFont.preferredFont(forTextStyle: .body))
                .textAlignment(.center)
                .textColor(CIComponentKitThemeCurrentConfig.textColor)
                .backgroundColor(UIColor.ci.hex(hex: index%2 == 0 ? 0xf2f2f2 : 0xC0C0C0))
            label.adjustsFontForContentSizeCategory = true
            self.view.addSubview(label)
        }
        
        let toggleThemeBtn = UIButton()
        toggleThemeBtn.y(view.bounds.maxY-64)
            .height(64)
            .width(view.ci.width)
            .backgroundColor(.green)
        toggleThemeBtn.titleLabel?.font(UIFont.preferredFont(forTextStyle: .headline))
        toggleThemeBtn.setTitle("Toggle theme", for: .normal)
        toggleThemeBtn.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        view.addSubview(toggleThemeBtn)
        
        let jumpBtn = UIButton()
        jumpBtn
            .y(toggleThemeBtn.frame.minY - 64)
            .height(64)
            .width(view.ci.width)
            .backgroundColor(UIColor.ci.hex(hex: 0x61dd72))
        jumpBtn.titleLabel?.font(UIFont.preferredFont(forTextStyle: .headline))
        jumpBtn.setTitle("JUMP TO CICUIViewController", for: .normal)
        jumpBtn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        view.addSubview(jumpBtn)

        changeTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CILoadingHUD.show("拼命加载中", blurStyle: .light, layoutStyle: .left)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CILoadingHUD.hide()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        CILoadingHUD.default.hide()
    }
    
    func jump() -> Swift.Void {
        let vc = CICUIViewController()
        vc.title = "CICUIViewController"
        vc.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeTheme() -> Swift.Void {
        CILoadingHUD.appearance().tintColor = UIColor.ci.hex(hex: 0xC0C0C0)
        
        let theme = CIComponentKitTheme.originTheme
        theme.config.textColor = UIColor.ci.hex(hex: 0xe2e2e2)
        theme.config.mainColor = UIColor.ci.hex(hex: 0xF7F6F6)
        theme.config.tintColor = UIColor.ci.hex(hex: 0xfcfcfc)
        theme.config.navigationBarLeftColor = UIColor.ci.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.ci.hex(hex: 0xfcfcfc)
        theme.config.navigationBarBackgroundColor = UIColor.ci.hex(hex: 0x26d6a4)
        theme.renderTheme()
    }

}

