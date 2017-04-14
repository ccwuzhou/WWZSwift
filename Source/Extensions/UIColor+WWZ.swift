//
//  UIColor+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/7.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public struct WWZRGBType {
    
    var r : Float = 0
    var g : Float = 0
    var b : Float = 0
    
    init(_ r: Float, _ g: Float, _ b: Float) {
        
        self.r = r
        self.g = g
        self.b = b
    }
    
    init(hsv: WWZHSVType) {
        
        if hsv.s == 0 {
            self.r = hsv.v
            self.g = hsv.v
            self.b = hsv.v
            return
        }
        
        let h = hsv.h/60
        
        let i = Int(h)
        
        let f = hsv.h - Float(i)
        let a = hsv.v * (1 - hsv.s)
        let b = hsv.v * (1 - hsv.s * f)
        let c = hsv.v * (1 - hsv.s * (1 - f))
        
        switch i {
        case 0:
            self.r = hsv.v; self.g = c; self.b = a
        case 1:
            self.r = b; self.g = hsv.v; self.b = a
        case 2:
            self.r = a; self.g = hsv.v; self.b = c
        case 3:
            self.r = a; self.g = b; self.b = hsv.v
        case 4:
            self.r = c; self.g = a; self.b = hsv.v
        case 5:
            self.r = hsv.v; self.g = a; self.b = b
        default:
            self.r = hsv.v
            self.g = hsv.v
            self.b = hsv.v
            break
        }
    }
}
public struct WWZHSVType {
    
    var h : Float
    var s : Float
    var v : Float
    
    init(_ h: Float, _ s: Float, _ v: Float) {
        
        self.h = h
        self.s = s
        self.v = v
    }
    
    init(rgb: WWZRGBType) {
        
        var max = fmaxf(rgb.g, rgb.b)
        max = fmaxf(rgb.r, max)
        
        var min : Float = fminf(rgb.g, rgb.b)
        min = fminf(rgb.r, min)
        
        if rgb.r == max {
            
            self.h = (rgb.g - rgb.b) / (max - min)
        }else if rgb.g == max {
        
            self.h = 2 + (rgb.b - rgb.r) / (max - min)
        }else {
            
            self.h = 4 + (rgb.r - rgb.g) / (max - min)
        }
        
        self.h = self.h * 60
        
        if self.h < 0 {
            self.h = self.h + 360
        }
        
        self.v = max
        self.s = (max-min)/max
    }
}


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

public extension UIColor {

    public var rgbType : WWZRGBType {
    
        guard let components = self.cgColor.components, let model = self.cgColor.colorSpace?.model else {
        
            return WWZRGBType(0, 0, 0)
        }
        
        var r, g, b : CGFloat
        
        switch model {
        case .monochrome:
            r = components[0]
            g = components[0]
            b = components[0]
        case .rgb:
            r = components[0]
            g = components[1]
            b = components[2]
        default:
            r = 0
            g = 0
            b = 0
        }
        return WWZRGBType(Float(r), Float(g), Float(b))
    }
    
    public var hsvType : WWZHSVType {
    
        return WWZHSVType(rgb: self.rgbType)
    }
}
