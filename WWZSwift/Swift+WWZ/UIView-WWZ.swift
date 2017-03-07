//
//  UIView-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UIView {

    var x : CGFloat {
        set{
            self.frame.origin.x = newValue;
        }
        get{
            return self.frame.origin.x;
        }
    }
    
    var y : CGFloat {
        set{
            self.frame.origin.y = newValue;
        }
        get{
            return self.frame.origin.y;
        }
    }
    
    var right : CGFloat {
        set{
            self.frame.origin.x = newValue - self.frame.size.width;
        }
        get{
            return self.frame.origin.x + self.frame.size.width;
        }
    }
    
    var bottom : CGFloat {
        set{
            self.frame.origin.y = newValue - self.frame.size.height;
        }
        get{
            return self.frame.origin.y + self.frame.size.height;
        }
    }
    
    var origin : CGPoint {
        set{
            self.frame.origin = newValue;
        }
        get{
            return self.frame.origin;
        }
    }
    
    var size : CGSize {
        set{
            self.frame.size = newValue;
        }
        get{
            return self.frame.size;
        }
    }
    
    var width : CGFloat {
        set{
            self.frame.size.width = newValue;
        }
        get{
            return self.frame.size.width;
        }
    }
    
    var height : CGFloat {
        set{
            self.frame.size.height = newValue;
        }
        get{
            return self.frame.size.height;
        }
    }
    
    var centerX : CGFloat {
        set{
            self.center.x = newValue;
        }
        get{
            return self.center.x;
        }
    }
    
    var centerY : CGFloat {
        set{
            self.center.y = newValue;
        }
        get{
            return self.center.y;
        }
    }
    
    public func wwz_alignCenter() {
    
        guard let superview = self.superview else {
            
            return;
        }
  
        self.origin = CGPoint(x: (superview.width-self.width)/2, y: (superview.height-self.height)/2)
    }
    
    public func wwz_alignCenterX() {
        
        guard let superview = self.superview else {
            
            return;
        }
        
        self.x = (superview.width-self.width)/2
    }
    public func wwz_alignCenterY() {
        
        guard let superview = self.superview else {
            
            return;
        }
        
        self.y = (superview.height-self.height)/2
    }
    
    public func wwz_alignRight(rightOffSet: CGFloat) {
        
        guard let superview = self.superview else {
            
            return;
        }
        
        self.right = superview.width-rightOffSet
    }
    
    public func wwz_alignBottom(bottomOffSet: CGFloat) {
        
        guard let superview = self.superview else {
            
            return;
        }
        
        self.bottom = superview.height-bottomOffSet
    }
}

extension UIView {

    convenience init(frame: CGRect, backgroundColor: UIColor?) {
        
        self.init(frame: frame)
        
        self.backgroundColor = backgroundColor
    }
}













