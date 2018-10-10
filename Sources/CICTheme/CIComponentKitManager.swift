//
//  CIComponentKitManager.swift
//  CIComponentKit
//
//  Created by ManoBoo on 15/09/2017.
//  Copyright © 2017 club.codeinventor. All rights reserved.
//

import UIKit

class CIComponentKitManager: NSObject {

    static let shareInstance = CIComponentKitManager()
    public var currentOrientation: UIDeviceOrientation = .portrait

    private override init() {
        super.init()
        // 监听设备旋转方向变化
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleOrientationChangeNotification(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    class func angleForCurrentOrientation(_ orientation: UIInterfaceOrientation) -> CGFloat {
        var angle = 0.0
        switch orientation {
        case .portrait:
            angle = 0.0
        case .portraitUpsideDown:
            angle = Double.pi
        case .landscapeLeft:
            angle =  -Double.pi/2
        case .landscapeRight:
            angle = Double.pi/2
        default:
            break
        }
        return CGFloat(angle)
    }

    class func transformForCurrentOrientation(_ orientation: UIInterfaceOrientation) -> CGAffineTransform {
        return CGAffineTransform.init(rotationAngle: angleForCurrentOrientation(orientation))
    }

    // MARK: - Event

    @objc func handleOrientationChangeNotification(_ notification: Notification) -> Swift.Void {

    }
}
