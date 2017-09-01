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
        self.view.ci.allInfomation()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(self.view.tintColor)
        CILoadingHUD.show("点击屏幕切换主题", blurStyle: .light, layoutStyle: .top)
    
        for index in 0...10 {
            let label = UILabel().ci.appearance
            label.frame = CGRect.init(x: 0, y: 100 + 44 * CGFloat(index), width: view.bounds.width, height: 44.0)
            label.text = "welcome to cicomponentkit~ \(index)"
            self.view.addSubview(label)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        CILoadingHUD.default.hide()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        CILoadingHUD.appearance().tintColor = UIColor.ci.random
        
        let theme = CIComponentKitTheme.originTheme
        
        theme.config.defaultFont = UIFont.systemFont(ofSize: CGFloat(arc4random_uniform(44)))
        theme.config.textColor = UIColor.ci.random
        theme.config.tintColor = UIColor.ci.random
        theme.config.navigationBarLeftColor = UIColor.ci.random
        
        theme.renderTheme()
        
    }
    
    

}

