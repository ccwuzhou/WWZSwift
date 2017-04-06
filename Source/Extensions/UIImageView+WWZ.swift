//
//  UIImageView+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/8.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UIImageView {

    public convenience init(imageName: String, contentMode: UIViewContentMode) {
        
        self.init(frame: CGRect.zero, imageName: imageName, contentMode: contentMode)
    }
    
    public convenience init(frame: CGRect, imageName: String, contentMode: UIViewContentMode) {
        
        self.init(image: UIImage(named: imageName))
        
        if !frame.equalTo(CGRect.zero) {
            self.frame = frame
        }
        
        self.contentMode = contentMode
    }
}
