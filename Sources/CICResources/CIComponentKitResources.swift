//
//  CIComponentKitResources.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/24.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

struct CIComponentKitResources {
    
    /// CIComponentKit需要的图片文件等
    public static var bundle: Bundle {
        let frameBundle = Bundle.init(for: CICLabel.self)
        let path = frameBundle.path(forResource: "CIComponentKitResources", ofType: "bundle")!
        return Bundle.init(path: path)!
    }
}

extension UIImage {
    struct cic {
        /// 返回 CIComponentKitResources.bundle 中的一张图片
        ///
        /// - Parameters:
        ///   - imageNamed: 图片名称
        ///   - ofType: 图片后缀,默认为 `png`
        ///   - inDirectory: 在哪个文件夹下面,默认为 `images` 目录下
        /// - Returns: 返回图片
        public static func bundle(_ imageNamed: String, ofType: String = "png", inDirectory: String? = "images") -> UIImage? {
            if imageNamed.characters.count > 0 {
                guard let path = CIComponentKitResources.bundle.path(forResource: imageNamed, ofType: ofType, inDirectory: inDirectory) else {
                    return nil
                }
                return UIImage.init(contentsOfFile: path)
            }
            return nil
        }
    }
}

