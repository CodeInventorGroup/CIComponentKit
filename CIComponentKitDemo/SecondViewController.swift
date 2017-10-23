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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

    func buildUI() -> Swift.Void {
        view.addSubview(tableView.frame(CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
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
        theme.config.textColor = UIColor.cic.random
        theme.config.mainColor = UIColor.cic.random
        theme.config.alertMessageColor = UIColor.cic.random
        theme.config.tintColor = UIColor.cic.hex(hex: 0xfcfcfc)
        theme.config.navigationBarLeftColor = UIColor.cic.hex(hex: 0xe2e2e2)
        theme.config.navigationItemTitleColor = UIColor.cic.random
        theme.config.navigationBarBackgroundColor = UIColor.cic.random
        theme.renderTheme()
        
        CICHUD.showAlert(String.LoremIpsum)
//        CICHUD.toast("主题切换成功😄", blurStyle: .extraLight)
    }
    
    //MARK: - CIComponentKitThemeChange
    
    override func didToggleTheme() {
        super.didToggleTheme()
        
        print("SecondViewController didToggleTheme")
        tableView.reloadData()
    }

}
