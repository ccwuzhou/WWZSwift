//
//  CALayer-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension CALayer {

    // MARK: -设置圆角半径
    public func wwz_setCorner(radius: CGFloat){
    
        self.wwz_setCorner(radius: radius, borderWidth: 0, borderColor: nil)
    }
    
    // MARK: -设置圆形描边
    public func wwz_setCorner(borderWidth: CGFloat, borderColor: UIColor?) {
    
        self.wwz_setCorner(radius: min(self.frame.size.width, self.frame.size.height)*0.5, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    // MARK: -设置描边
    public func wwz_setCorner(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?){
    
        self.masksToBounds = true
        self.cornerRadius = radius
        self.borderWidth = borderWidth
        self.borderColor = borderColor?.cgColor
    }
    
    // MARK: -设置阴影
    public func wwz_setShadowOffsetY(shadowColor: UIColor?, offsetY: CGFloat) {
    
        self.wwz_setShadow(shadowColor: shadowColor, offset: CGSize(width: 0, height: offsetY))
    }
    
    // MARK: -设置阴影
    public func wwz_setShadow(shadowColor: UIColor?, offset: CGSize) {
    
        self.shadowColor = shadowColor?.cgColor
        self.shadowOffset = offset
        self.shadowOpacity = 1
        self.shadowRadius = 0
    }
    // MARK: -暂停动画
    public func wwz_pauseAnimation() {
        
        self.speed = 0.0
        self.timeOffset = self.convertTime(CACurrentMediaTime(), from: nil)
    }
    // MARK: -恢复动画
    public func wwz_resumeAnimation() {
        
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        self.beginTime = self.convertTime(CACurrentMediaTime(), from: nil) - self.timeOffset
    }
}
