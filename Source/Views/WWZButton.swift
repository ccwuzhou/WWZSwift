//
//  WWZButton.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

open class WWZButton: UIButton {

    public var spaceY : CGFloat = 0.0;
    
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        guard var imageFrame = self.imageView?.frame else { return }
        
        guard var titleFrame = self.titleLabel?.frame else { return }

        // title
        titleFrame.size = self.titleLabel!.textRect(forBounds: self.bounds, limitedToNumberOfLines: 1).size
        
        // imageView
        let space = self.spaceY < 5.0 ? 5.0 : self.spaceY
        
        imageFrame.origin.x = (self.bounds.size.width-imageFrame.size.width)*0.5;
        imageFrame.origin.y = (self.frame.size.height-imageFrame.size.height-titleFrame.size.height-space)*0.5;
        
        titleFrame.origin.x = (self.bounds.size.width-titleFrame.size.width)*0.5;
        titleFrame.origin.y = imageFrame.maxY+space;
        
        self.imageView?.frame = imageFrame;
        
        self.titleLabel?.frame = titleFrame;
    }
}
