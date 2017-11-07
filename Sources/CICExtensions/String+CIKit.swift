//
//  String+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 15/09/2017.
//  Copyright © 2017 club.codeinventor. All rights reserved.
//

import Foundation

public extension String {
    struct cic {
        /// a~Z + 0~9
        public static let UniversalCharacter: [String] = "a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9".components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        
        /// 生成一个随机字符串
        ///
        /// - Parameter length: 字符串的长度,默认为6
        /// - Returns: 随机字符串
        public  static func random(_ length: Int = 6) -> String {
            var ranStr = ""
            for _ in 0..<length {
                let index = Int(arc4random() % 62)
                ranStr += UniversalCharacter[index]
            }
            return ranStr
        }
    }
}

extension String {
    
    public func cicHeight(_ maxWidth: CGFloat = .screenWidth,
                          font: UIFont = UIFont.cic.systemFont) -> CGFloat {
        
        let str = NSString.init(string: self)
        return str.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT)),
                                options:.usesLineFragmentOrigin,
                                attributes: [.font: font],
                                context: nil).height
    }
    
    public func cicWidth(_ maxHeight: CGFloat = UIFont.systemFontSize,
                         font: UIFont = UIFont.cic.systemFont) -> CGFloat {
        let str = NSString.init(string: self)
        return str.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: maxHeight),
                                options:.usesLineFragmentOrigin,
                                attributes: [.font: font],
                                context: nil).width
    }
}
