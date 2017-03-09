//
//  UIColor+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/7.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit


// MARK: - UIColor
public extension UIColor {
    
    public class func colorFromRGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        
        return self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    public class func colorFromRGBA(rgba: UInt) -> UIColor {
        
        return self.init(red: ((CGFloat)((rgba & 0xFF000000) >> 24))/255.0,
                         green: ((CGFloat)((rgba & 0xFF0000) >> 16))/255.0,
                         blue: ((CGFloat)((rgba & 0xFF00) >> 8))/255.0,
                         alpha: ((CGFloat)(rgba & 0xFF))/255.0)
    }
    
}
