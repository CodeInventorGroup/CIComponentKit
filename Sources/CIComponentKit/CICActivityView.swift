//
//  CICActivityView.swift
//  CIComponentKit
//
//  Created by ManoBoo on 2017/10/14.
//  Copyright © 2017年 club.codeinventor. All rights reserved.
//  苹果大部分App中的指示器都是这个style

import UIKit

public class CICActivityView: UIView {

    static let `default` = CICActivityView.init(frame: .zero)

    var strokeColor = UIColor.cic.hex(hex: 0x808080).cgColor
    var fillColor = UIColor.clear {
        didSet {
            self.backgroundColor = fillColor
        }
    }
    var lineWidth: CGFloat = 4.0

    static let hud: UIVisualEffectView = {
        let hud = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .extraLight))
            .backgroundColor(.white)
        hud.layer.cornerRadius = 8.0
        hud.layer.masksToBounds = true
        hud.contentView.addSubview(CICActivityView.default)
        return hud
    }()

    /// 动画停止是是否隐藏,和系统UIActivityView保持一致
    var isHideWhenStopped = true

    let shape = CAShapeLayer.init()

    private let animationKey = "CICActivityView_animationKey"

    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        let center = CGPoint.init(x: rect.width/2, y: rect.height/2)
        let half = CGFloat.maximum(rect.width, rect.height) / 2.0
        let path = UIBezierPath.init(arcCenter: center,
                                     radius: half * 0.9,
                                     startAngle: 0.0,
                                     endAngle: CGFloat.pi * 2.0,
                                     clockwise: false)
        shape.strokeColor = strokeColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeStart = 0
        shape.strokeEnd = 0.8
        shape.path = path.cgPath
        shape.lineWidth = lineWidth
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

extension CICHUD {

    /// 类似于MBProgressHUB 一样的加载框
    public class func showActivityView(superView: UIView? = UIApplication.shared.keyWindow,
                                       backgroundSize: CGSize = 100.makeSize,
                                       hudSize: CGSize = 60.makeSize) {
        guard let superView = superView else {
            return
        }
        CICActivityView.hud.removeFromSuperview()
        let hud = CICActivityView.hud.size(backgroundSize)
            .center(superView.cic.internalCenter)
        CICActivityView.default.size(hudSize)
            .center(hud.cic.internalCenter)
        superView.addSubview(hud)
        CICActivityView.default.startAnimation()
    }

    // hide activityView
    public class func hideActivityView() {
        CICActivityView.hud.removeFromSuperview()
    }
}
