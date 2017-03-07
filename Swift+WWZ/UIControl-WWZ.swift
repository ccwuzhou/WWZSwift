//
//  UIControl-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UISwitch {

    convenience init(onTintColor: UIColor?, tintColor: UIColor?, thumbTintColor: UIColor?) {
        
        self.init()
        if let onTintColor = onTintColor {
            self.onTintColor = onTintColor
        }
        
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        
        if let thumbTintColor = thumbTintColor {
            self.thumbTintColor = thumbTintColor
        }
    }
    
    public func wwz_setTarget(target: Any?, action: Selector) {
    
        self.addTarget(target, action: action, for: .valueChanged)
    }
}

extension UISlider {
    
    // MARK: -实现左右切片slider
    convenience init(frame: CGRect, minImageName: String, maxImageName: String, thumbImageName: String) {
        
        self.init(frame: frame, minTrackImage: UIImage(named: minImageName), maxTrackImage: UIImage(named: maxImageName), thumbImage: UIImage(named: thumbImageName))
    }
    // MARK: -实现左右切片slider
    convenience init(frame: CGRect, minTrackImage: UIImage?, maxTrackImage: UIImage?, thumbImage: UIImage?) {
        
        self.init(frame: frame)
        
        if let minTrackImage = minTrackImage {
            
            self.setMinimumTrackImage(self.stretchImage(image: minTrackImage) , for: .normal)
        }
        if let maxTrackImage = maxTrackImage {
            
            self.setMaximumTrackImage(self.stretchImage(image: maxTrackImage), for: .normal)
        }
        if let thumbImage = thumbImage {
            
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    // MARK: -添加滑动结束事件
    public func wwz_setEndTarget(target: Any?, action: Selector) {
        
        self.addTarget(target, action: action, for: .touchUpInside)
        self.addTarget(target, action: action, for: .touchUpOutside)
        self.addTarget(target, action: action, for: .touchCancel)
    }
    // MARK: -添加滑动改变事件
    public func wwz_setChangeTarget(target: Any?, action: Selector) {
        
        self.addTarget(target, action: action, for: .valueChanged)
    }
    
    
    // MARK: -私有方法
    private func stretchImage(image: UIImage!) -> UIImage {
        
        return image.resizableImage(withCapInsets: UIEdgeInsetsMake(0, image.size.width*0.5, 0, image.size.width*0.5), resizingMode: .stretch)
    }
}

