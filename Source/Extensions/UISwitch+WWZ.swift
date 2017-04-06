//
//  UIControl-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UISwitch {

    public convenience init(onTintColor: UIColor?, tintColor: UIColor?, thumbTintColor: UIColor?) {
        
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



