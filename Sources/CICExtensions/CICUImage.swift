//
//  CICUImage.swift
//  CIComponentKit
//
//  Created by ManoBoo on 12/09/2017.
//  Copyright © 2017 codeinventor. All rights reserved.
//

import UIKit

extension CGSize {
    func valid() -> Bool {
        if width > 0 && height > 0 {
            return true
        }
        return false
    }
}

extension CGFloat {
    public static let screenScale: CGFloat =  {
        return UIScreen.main.scale
    }()
}

extension UIImage {
    
    class func image(color: UIColor = UIColor.ci.clear, size: CGSize, cornerRadius: CGFloat = 0.0) -> UIImage? {
        var image: UIImage? = nil
        
        if size.valid() {
            
        }
        
        guard size.valid() else {
            return nil
        }
        
        let opaque = cornerRadius == 0.0
        UIGraphicsBeginImageContextWithOptions(size, opaque, CGFloat.screenScale)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            
            if cornerRadius > 0.0 {
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: size), cornerRadius: cornerRadius)
                path.addClip()
                path.fill()
            }else {
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
