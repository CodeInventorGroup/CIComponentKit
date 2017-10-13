//
//  CICActivityView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/14.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//

import UIKit

public class CICActivityView: UIView {
    
    var strokeColor = UIColor.cic.hex(hex: 0x808080).cgColor
    var fillColor = UIColor.clear {
        didSet {
            self.backgroundColor = fillColor
        }
    }
    var isHideWhenStopped = true
    
    
    let shape = CAShapeLayer.init()
    
    fileprivate let animationKey = "CICActivityView_animationKey"
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint.init(x: rect.width/2, y: rect.height/2)
        let half = CGFloat.maximum(rect.width, rect.height) / 2.0
        let path = UIBezierPath.init(arcCenter: center, radius: half * 0.94, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: false)
        shape.strokeColor = strokeColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeStart = 0
        shape.strokeEnd = 0.8
        shape.path = path.cgPath
        shape.lineWidth = half * 0.06
        shape.lineJoin = kCALineJoinRound
        shape.lineCap = kCALineCapRound
        self.layer.addSublayer(shape)
    }
    
    public func startAnimation() {
        self.backgroundColor = fillColor
        self.isHidden = false
        let animation1 = CABasicAnimation.init()
        animation1.keyPath = "transform.rotation.z"
        animation1.toValue = 2 * CFloat.pi
        animation1.duration = 1.25
        animation1.repeatCount = HUGE
        self.layer.add(animation1, forKey: animationKey)
    }
    
    public func stopAnimation() {
        self.layer.removeAnimation(forKey: animationKey)
        self.isHidden = isHideWhenStopped
    }
}
