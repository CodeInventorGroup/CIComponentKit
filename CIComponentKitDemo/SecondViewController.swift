//
//  SecondViewController.swift
//  CIComponentKit
//
//  Created by ManoBoo on 14/09/2017.
//  Copyright © 2017 club.codeinventor. All rights reserved.
//

import UIKit
import CIComponentKit

class SecondViewController: CICUIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView.init(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildUI()
    }

    func buildUI() -> Swift.Void {
        view.addSubview(tableView.frame(CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        
//        let toolBar = UIToolbar().y(64)
//                .height(44)
//                .width(view.bounds.width)
//        toolBar.barStyle = .default
//        
//        let item1 = UIBarButtonItem.init(title: "ManoBoo", style: .plain, target: nil, action: nil)
//        item1.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black], for: .normal)
//        
//        let item2 = UIBarButtonItem.init(title: "ZRFlower", style: .plain, target: nil, action: nil)
//        item2.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.green], for: .normal)
//        
//        let item3 = UIBarButtonItem.init(title: "二蛋", style: .plain, target: nil, action: nil)
//        item3.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.green], for: .normal)
//        
//        let item4 = UIBarButtonItem.init(title: "露阳", style: .plain, target: nil, action: nil)
//        item4.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.green], for: .normal)
//        
//        toolBar.setItems([item1, item2, item3, item4], animated: true)
//        view.addSubview(toolBar)
    }
    

    //MAKR: - UITableViewDataSource & UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_")!
        cell.textLabel?.line(0)
            .text(String.LoremIpsum)
            .textColor(CIComponentKitThemeCurrentConfig.textColor)
            .font(UIFont.systemFont(ofSize: 10 + CGFloat(arc4random_uniform(14))))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let theme = CIComponentKitTheme.originTheme
        theme.config.textColor = UIColor.ci.random
        theme.config.mainColor = UIColor.ci.hex(hex: 0xF7F6F6)
        theme.config.tintColor = UIColor.ci.hex(hex: 0xfcfcfc)
        theme.config.navigationBarLeftColor = UIColor.ci.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.ci.hex(hex: 0xfcfcfc)
        theme.config.navigationBarBackgroundColor = UIColor.ci.hex(hex: 0x26d6a4)
        theme.renderTheme()
    }
    
    //MARK: - CIComponentKitThemeChange
    
    override func didToggleTheme() {
        super.didToggleTheme()
        
        print("SecondViewController didToggleTheme")
        tableView.reloadData()
    }

}
