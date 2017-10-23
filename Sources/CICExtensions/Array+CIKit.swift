//
//  Array+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/23.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import Foundation

extension Array {
    
    func safeElement(at: Int) -> Element? {
        if at < self.count {
            return self[at]
        }
        return nil
    }
}
