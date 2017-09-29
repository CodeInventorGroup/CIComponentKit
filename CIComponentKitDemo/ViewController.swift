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
        
        let label = UILabel.cic.appearance
        label.frame(CGRect.init(x: 0, y: 64, width: view.bounds.width, height: 200))
            .line(0)
            .text(String.LoremIpsum)
            .font(UIFont.preferredFont(forTextStyle: .body))
            .textAlignment(.center)
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
            .backgroundColor(UIColor.cic.hex(hex:  0xf2f2f2))
            .longPressAction(.copy)
            .copyRange(NSMakeRange(0, 5))
        label.copySuccessClousure = {
            if #available(iOS 9.0, *) {
                CICHUD.toast("复制成功", blurStyle: .extraLight)
            }
        }
        self.view.addSubview(label)
        
        let toggleThemeBtn = UIButton()
        toggleThemeBtn.y(view.bounds.maxY-64)
            .height(64)
            .width(equalTo: view)
            .backgroundColor(UIColor.cic.hex(hex: 0x06e2c9))
        toggleThemeBtn.titleLabel?.font(UIFont.preferredFont(forTextStyle: .headline))
        toggleThemeBtn.setTitle("Toggle theme", for: .normal)
        toggleThemeBtn.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        view.addSubview(toggleThemeBtn)
        
        let jumpBtn = UIButton()
        jumpBtn
            .y(toggleThemeBtn.frame.minY - 64)
            .height(64)
            .width(equalTo: view)
            .backgroundColor(UIColor.cic.hex(hex: 0x22a9e8))
        jumpBtn.titleLabel?.font(UIFont.preferredFont(forTextStyle: .headline))
        jumpBtn.setTitle("JUMP TO CICUIViewController", for: .normal)
        jumpBtn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        view.addSubview(jumpBtn)

        changeTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 9.0, *) {
             CICHUD.show("正在加载~", blurStyle: .extraLight, layoutStyle: .left)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if #available(iOS 9.0, *) {
            CICHUD.default.hide()
        }
    }
    
    func jump() -> Swift.Void {
        let vc = SecondViewController()
        vc.title = "CICUIViewController"
        vc.view.backgroundColor(CIComponentKitThemeCurrentConfig.mainColor)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeTheme() -> Swift.Void {
        
        let theme = CIComponentKitTheme.originTheme
        theme.config.textColor = UIColor.cic.random
        theme.config.mainColor = UIColor.cic.hex(hex: 0xF7F6F6)
        theme.config.tintColor = UIColor.cic.hex(hex: 0xfcfcfc)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.hex(hex: 0xfcfcfc)
        theme.config.navigationBarBackgroundColor = UIColor.cic.hex(hex: 0x26d6a4)
        theme.renderTheme()
    }

}

