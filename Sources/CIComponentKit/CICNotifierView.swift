//
//  CICNotifierView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/24.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  类似于iOS原生顶部通知

import UIKit
import LayoutKit


public struct CICNotifierViewType: Hashable{

    // 提供四种样式
    public static let error = CICNotifierViewType("")
    public static let status = CICNotifierViewType("")
    public static let success = CICNotifierViewType("")
    public static let warning = CICNotifierViewType("")
    
    var image: UIImage?
    var color: UIColor
    fileprivate var imageName: String
    
    
    init(_ imageNamed: String, color: UIColor = UIColor.cic.hex(hex: 0x39B54A)) {
        self.imageName = imageNamed
        self.color = color
        self.image = UIImage.init(named: imageNamed)
    }
    
    public var hashValue: Int {
        return imageName.hashValue
    }
    
    public static func ==(lhs: CICNotifierViewType, rhs: CICNotifierViewType) -> Bool {
        return false
    }
}

/// CICNotifierView 四种样式的默认Configure
public var CICNotifierViewConfigure: [CICNotifierViewType: (String, UIColor)]
    = [.error: ("error_circle", UIColor.cic.hex(hex: 0xF85359)),
       .status: ("status_circle", UIColor.cic.hex(hex: 0x1991EB)),
       .success: ("right_circle", UIColor.cic.hex(hex: 0x39B54A)),
       .warning: ("status_circle", UIColor.cic.hex(hex: 0xF7981C))]

class CICNotifierViewLayout: SizeLayout<View> {
    
    ///
    ///
    /// - Parameters:
    ///   - image: image
    ///   - title: title
    ///   - isShowClose: 展示关闭按钮
    ///   - autoHide: 是否自动隐藏
    public init(type: CICNotifierViewType, title: String = "",
                isShowClose: Bool = true,
                autoHide: Bool = true,
                viewReuseId: String = "CICNotifierView_ID") {
        
        let imageLayout = SizeLayout<UIImageView>.init(width: 16, height: 16, alignment: .center, viewReuseId: "imageLayout", sublayout: nil) { (imageView) in
            switch (type) {
                case .error:
                    imageView.image = UIImage.cic.bundle(CICNotifierViewConfigure[.error]!.0)
                        break
                case .status:
                    imageView.image = UIImage.cic.bundle(CICNotifierViewConfigure[.status]!.0)
                        break
                case .success:
                    imageView.image = UIImage.cic.bundle(CICNotifierViewConfigure[.success]!.0)
                        break
                case .warning:
                    imageView.image = UIImage.cic.bundle(CICNotifierViewConfigure[.warning]!.0)
                        break
            default:
                    imageView.image = type.image
                    break
            }
        }
        
        let titleLabelLayout = LabelLayout.init(text: title, font: UIFont.cic.preferred(.body), numberOfLines: 0, alignment: .center, viewReuseId: "title") { (label) in
            
        }
        
        let stackLayout = StackLayout<View>.init(axis: .horizontal, spacing: 36, alignment: .center, viewReuseId: "content", sublayouts: [imageLayout, titleLabelLayout]) { (view) in
            
        }
        super.init(minWidth: CGFloat.screenWidth - 20, maxWidth: CGFloat.screenWidth - 20, minHeight: 36, maxHeight: 100, alignment: .center, viewReuseId: viewReuseId, sublayout: stackLayout) { (view) in
            switch (type) {
            case .error:
                view.backgroundColor(CICNotifierViewConfigure[.error]!.1)
                break
            case .status:
                view.backgroundColor(CICNotifierViewConfigure[.status]!.1)
                break
            case .success:
                view.backgroundColor(CICNotifierViewConfigure[.success]!.1)
                break
            case .warning:
                view.backgroundColor(CICNotifierViewConfigure[.warning]!.1)
                break
            default:
                view.backgroundColor(type.color)
                break
            }
        }
    }
}

extension CICHUD {
    
    
    public class func showNotifier(_ type: CICNotifierViewType = .status,
                            title: String,
                            isShowClose: Bool = true,
                            autoHide: Bool = true) {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        let notifierLayout = CICNotifierViewLayout.init(type: type, title: title, isShowClose: isShowClose, autoHide: autoHide, viewReuseId: "CICNotifierView_ID")
        notifierLayout.arrangement(origin: CGPoint.init(x: 10, y: 20), width: CGFloat.screenWidth - 20, height: nil).makeViews(in: keyWindow)
    }
}
