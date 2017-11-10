//
//  CICUImage.swift
//  CIComponentKit
//
//  Created by ManoBoo on 12/09/2017.
//  Copyright © 2017 codeinventor. All rights reserved.
//
//  NOTICE:
//  UIImage+Gif is rewrite by https://github.com/kiritmodi2702/GIF-Swift/blob/master/GIF-Swift/iOSDevCenters%2BGIF.swift

import UIKit
import ImageIO

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension UIImage {

    /// create image with UIColor
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
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: size),
                                             cornerRadius: cornerRadius)
                path.addClip()
                path.fill()
            } else {
                context.fill(CGRect(origin: .zero, size: size))
            }
        }

        image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        return image
    }

    /// gifImage with `Data`
    public class func gifImage(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        return UIImage.animatedImage(source: source)
    }

    /// gifImage with url
    public class func gifImage(url: String) -> UIImage? {
        guard let bundleUrl = URL.init(string: url) else {
            print("image <\(url)> doesn't exist")
            return nil
        }
        guard let imageData = try? Data.init(contentsOf: bundleUrl) else {
            print("image <\(bundleUrl)> get failed.")
            return nil
        }
        return gifImage(data: imageData)
    }

    /// gifImage with name, not need `.gif` extension
    public class func gifImage(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        return gifImage(data: imageData)
    }

    // UIImage+Gif implementation begin
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                        to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1
        }
        return delay
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a < b {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }

    class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        var gcd = array[0]
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        return gcd
    }

    class func animatedImage(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delay = UIImage.delayForImageAtIndex(i, source: source)
            delays.append(Int(delay * 1000.0)) //seconds -> ms
        }
        let duration: Int = {
            var sum = 0
            for val: Int in delays {
                sum += val
            }
            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
    // UIImage+Gif implementation end
}
