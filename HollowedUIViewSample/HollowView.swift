//
//  HollowView.swift
//  HollowedUIViewSample
//
//  Created by MORITA NAOKI on 2015/02/01.
//  Copyright (c) 2015年 molabo. All rights reserved.
//

import UIKit

class HollowView: UIView {
    
    var hollowRadius = 60.0 as CGFloat
    lazy var hollowPoint: CGPoint = {
        return CGPoint(
            x: CGRectGetWidth(self.bounds) / 2.0,
            y: CGRectGetHeight(self.bounds) / 2.0
        )
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let rect = CGRect(
            x: self.hollowPoint.x - self.hollowRadius,
            y: self.hollowPoint.y - self.hollowRadius,
            width: self.hollowRadius * 2.0,
            height: self.hollowRadius * 2.0
        )
        let hollowPath = UIBezierPath(roundedRect: rect, cornerRadius: self.hollowRadius)
        if !CGRectContainsPoint(self.bounds, point) || hollowPath.containsPoint(point) {
            return nil
        }
        return self
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 繰り抜きたいレイヤーを作成する（今回は例として半透明にした）
        let hollowTargetLayer = CALayer()
        hollowTargetLayer.bounds = self.bounds
        hollowTargetLayer.position = CGPoint(
            x: CGRectGetWidth(self.bounds) / 2.0,
            y: CGRectGetHeight(self.bounds) / 2.0
        )
        hollowTargetLayer.backgroundColor = UIColor.blackColor().CGColor
        hollowTargetLayer.opacity = 0.5
        
        // 四角いマスクレイヤーを作る
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = hollowTargetLayer.bounds
        
        // 塗りを反転させるために、pathに四角いマスクレイヤーを重ねる
        let ovalRect =  CGRect(
            x: self.hollowPoint.x - self.hollowRadius,
            y: self.hollowPoint.y - self.hollowRadius,
            width: self.hollowRadius * 2.0,
            height: self.hollowRadius * 2.0
        )
        let path =  UIBezierPath(ovalInRect: ovalRect)
        path.appendPath(UIBezierPath(rect: maskLayer.bounds))
        
        maskLayer.fillColor = UIColor.blackColor().CGColor
        maskLayer.path = path.CGPath
        maskLayer.position = CGPoint(
            x: CGRectGetWidth(hollowTargetLayer.bounds) / 2.0,
            y: CGRectGetHeight(hollowTargetLayer.bounds) / 2.0
        )
        // マスクのルールをeven/oddに設定する
        maskLayer.fillRule = kCAFillRuleEvenOdd
        hollowTargetLayer.mask = maskLayer
        
        // サブレイヤーとしてadd
        self.layer.addSublayer(hollowTargetLayer)
    }
}
