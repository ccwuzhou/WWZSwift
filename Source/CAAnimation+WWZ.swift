//
//  CAAnimation+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/10.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public enum WWZAnimationKeyPath : String {
    
    case position = "position"
    case translation = "transform.translation"      // 点移动
    case translationX = "transform.translation.x"   // x方向移动
    case translationY = "transform.translation.y"   // y方向移动
    
    case rotation = "transform.rotation"
    case rotationX = "transform.rotation.x"
    case rotationY = "transform.rotation.y"
    case rotationZ = "transform.rotation.z"
    
    case scale = "transform.scale"                  // 比例
    case scaleX = "transform.scale.x"
    case scaleY = "transform.scale.y"
    
    case opacity = "opacity"                        // 透明度
}

public extension CABasicAnimation {
    
    public convenience init(keyPath: WWZAnimationKeyPath, fromValue: Any?, toValue: Any?, duration: TimeInterval, autoreverses: Bool) {
        
        self.init(keyPath: keyPath.rawValue)
        
        if let fromValue = fromValue {
            self.fromValue = fromValue
        }
  
        self.toValue = fromValue
        self.duration = duration
        
        self.autoreverses = autoreverses
        
        self.repeatCount = MAXFLOAT
        self.isRemovedOnCompletion = false
        self.fillMode = kCAFillModeForwards
    }
}
