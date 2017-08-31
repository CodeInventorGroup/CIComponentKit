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
        self.view.backgroundColor = UIColor.black
        
        print(self.view.tintColor)
        CILoadingHUD.show("welcome to cicomponentkit", blurStyle: .extraLight, layoutStyle: .top)
    
        let label = UILabel().ci.appearance
        label.frame = CGRect.init(x: 0, y: 100, width: 220, height: 44)
        label.text = "welcome to cicomponentkit~"
        self.view.addSubview(label)
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
        
        self.view.backgroundColor = UIColor.ci.random
        
        CILoadingHUD.appearance().tintColor = UIColor.ci.random
        
        var theme = CIComponentKitTheme.originTheme
        theme.textColor = UIColor.ci.random
        theme.navigationBarLeftColor = UIColor.ci.random
        theme.renderTheme()
        
    }
    
    

}

