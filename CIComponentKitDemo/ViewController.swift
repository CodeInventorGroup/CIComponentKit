    //
//  ViewController.swift
//  CIComponentKitDemo
//
//  Created by ManoBoo on 2017/8/29.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//

import UIKit
import CIComponentKit
import LayoutKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view, typically from a nib.
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
        let label = UILabel.cic.appearance
        label.frame(CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 200))
            .line(0)
            .text(String.LoremIpsum)
            .font(UIFont.preferredFont(forTextStyle: .body))
            .textAlignment(.center)
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
            .backgroundColor(UIColor.cic.hex(hex:  0xf2f2f2))
            .longPressAction(.copy)
            .copyRange(NSMakeRange(0, 5))
        label.copySuccessClousure = {
                CICHUD.showNetWorkStatusChange()
        }
        self.view.addSubview(label)

        let toggleThemeBtn = UIButton()
        toggleThemeBtn.y(view.bounds.maxY-64)
            .height(64)
            .width(equalTo: view)
            .backgroundColor(UIColor.cic.hex(hex: 0x06e2c9))
        toggleThemeBtn.titleLabel?.font(UIFont.cic.preferred(.body))
        toggleThemeBtn.setTitle("Toggle theme", for: .normal)
        toggleThemeBtn.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        view.addSubview(toggleThemeBtn)
        
        let jumpBtn = UIButton()
        jumpBtn
            .y(toggleThemeBtn.frame.minY - 64)
            .height(64)
            .width(equalTo: view)
            .backgroundColor(UIColor.cic.hex(hex: 0x22a9e8))
        jumpBtn.titleLabel?.font(UIFont.cic.preferred(.headline))
        jumpBtn.setTitle("JUMP TO CICUIViewController", for: .normal)
        jumpBtn.addTarget(self, action: #selector(jump), for: .touchUpInside)
        view.addSubview(jumpBtn)

        changeTheme()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    class DrawDemo: UIView {
        
        let shape = CAShapeLayer.init()
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            let center = CGPoint.init(x: rect.width/2, y: rect.height/2)
            let path = UIBezierPath.init(arcCenter: center, radius: 50, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: false)
            
            shape.strokeColor = UIColor.cic.hex(hex: 0xC0C0C0).cgColor
            shape.fillColor = UIColor.clear.cgColor
            shape.strokeStart = 0
            shape.strokeEnd = 0.75
            shape.path = path.cgPath
            shape.lineWidth = 6
            shape.lineJoin = kCALineJoinRound
            shape.lineCap = kCALineCapRound
            self.layer.addSublayer(shape)
        }
        
        func startAnimation() {
            self.backgroundColor = UIColor.clear
            let animation1 = CABasicAnimation.init()
            animation1.keyPath = "transform.rotation.z"
            animation1.toValue = 2 * CFloat.pi
            animation1.duration = 1.0
            animation1.repeatCount = HUGE
            self.layer.add(animation1, forKey: "sss")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        CICHUD.show("正在加载~", blurStyle: .extraLight, layoutStyle: .right)
        
        let loading = DrawDemo.init(frame: CGRect.init(x: 50, y: 300, width: 120, height: 120))
        loading.startAnimation()
        view.addSubview(loading)
        
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
        CICHUD.showGuide(title, message: message, animated: true)
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
        theme.config.mainColor = UIColor.cic.random
        theme.config.tintColor = UIColor.cic.hex(hex: 0xDF312E)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.random
        theme.config.navigationBarBackgroundColor = UIColor.cic.random
        theme.config.alertMessageColor = UIColor.cic.random
        theme.renderTheme()
    }
}
    
    

    
    

