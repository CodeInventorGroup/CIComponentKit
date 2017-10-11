//
//  CICUImage.swift
//  CIComponentKit
//
//  Created by ManoBoo on 12/09/2017.
//  Copyright © 2017 codeinventor. All rights reserved.
//

import UIKit
import LayoutKit

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
    
    public class func image(color: UIColor = UIColor.cic.clear, size: CGSize, cornerRadius: CGFloat = 0.0) -> UIImage? {
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

public class ManoBooProfileLayout: InsetLayout<UIView> {
    
    public init(imageName: String, name: String, headline: String) {
        let image = SizeLayout<UIImageView>(
            width: 80,
            height: 80,
            alignment: .center,
            config: { imageView in
                imageView.image = UIImage(named: imageName)
                
                // Not the most performant way to do a corner radius, but this is just a demo.
                imageView.layer.cornerRadius = 40
                imageView.layer.masksToBounds = true
        }
        )
        
        let nameLayout = LabelLayout(text: name, font: UIFont.systemFont(ofSize: 40))
        
        let headlineLayout = LabelLayout(
            text: headline,
            font: UIFont.systemFont(ofSize: 24.0),
            config: { label in
                label.textColor(UIColor.darkGray)
        }
        )
        
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 8,
                sublayouts: [
                    image,
                    StackLayout(axis: .vertical, spacing: 2, sublayouts: [nameLayout, headlineLayout])
                ]
            ),
            config: { view in
                    view.backgroundColor = UIColor.white
            }
        )
    }
}
