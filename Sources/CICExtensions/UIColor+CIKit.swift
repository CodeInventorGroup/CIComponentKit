//
//  UIColor+CIKit.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/8/30.
//  Copyright © 2017年 CodeInventor. All rights reserved.
//


public extension UIColor {
    
    struct cic {
        
        private typealias CIComponentColor = cic
        
        enum ColorFormatter {
            case hex(UInt32)
            case string(String)
        }
        
        //MARK: Random Color
        public static var random: UIColor {
            let red = Int(arc4random_uniform(256))
            let green = Int(arc4random_uniform(256))
            let blue = Int(arc4random_uniform(256))
            
            return CIComponentColor.rgb(red: red, green: green, blue: blue)
        }
        
        public static var clear: UIColor {
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.0)
        }
    
        //MARK: RGB Color
        public static func rgb(red : Int, green : Int, blue : Int) -> UIColor {
            return CIComponentColor.rgb(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        public static func rgb(red : Int, green : Int, blue : Int, alpha : CGFloat) -> UIColor {
            assert(red >= 0 && red <= 255, "red输入无效")
            assert(green >= 0 && green <= 255, "green输入无效")
            assert(blue >= 0 && blue <= 255, "blue输入无效")
            
            return UIColor(red : CGFloat(red) / 255.0, green : CGFloat(green) / 255.0, blue : CGFloat(red) / 255.0, alpha: alpha)
        }
        
        //MARK: srbg color
        public static func sRgb(red: Int, green: Int, blue: Int) -> UIColor {
            return CIComponentColor.sRgb(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        public static func sRgb(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
            assert(red >= 0 && red <= 255, "red输入无效")
            assert(green >= 0 && green <= 255, "green输入无效")
            assert(blue >= 0 && blue <= 255, "blue输入无效")
            
            if #available(iOS 10.0, *) {
                return UIColor(displayP3Red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
            } else {
                // Fallback on earlier versions
                return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
            }
        }
        
        //MARK: Hex Color
        public static func hex(hex : UInt32) -> UIColor {
            return self.hex(hex: hex, alpha: 1.0)
        }
        
        public static func hex(hex : UInt32, alpha : CGFloat) -> UIColor {
            return UIColor(red:CGFloat((hex & 0xFF0000) >> 16) / 255.0, green: CGFloat((hex & 0x00FF00) >> 8) / 255.0, blue: CGFloat(hex & 0x0000FF) / 255.0, alpha: alpha)
        }
        
        public static func hexString(hex : String) -> UIColor {
            return hexString(hex: hex, alpha: 1.0)
        }
        
        public static func hexString(hex : String, alpha : CGFloat) -> UIColor {
            var cString : String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }
            
            if cString.characters.count != 6 {
                //输入错误时 默认返回白色
                return UIColor.white
            }
            
            var rgbValue : UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
        }

    }
}


extension CGFloat {
    
    var maxCGFloatValue : CGFloat {
        get {
            return CGFloat(Int(self))
        }
    }
}

