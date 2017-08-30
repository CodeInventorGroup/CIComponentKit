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
        
        CILoadingHUD.show("welcome to cicomponentkit", blurStyle: .extraLight, layoutStyle: .top)
        
//        CILoaingHUD.show("ManoBoo", layoutStyle: .top)
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
        
        var theme = CIComponentKitTheme.originTheme
        theme.tintColor = UIColor.ci.random()
        theme.navigationBarLeftColor = UIColor.ci.random()
        theme.renderTheme()
        
    }
    
    

}

