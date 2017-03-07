//
//  UILabel-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/25.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UILabel {

    // MARK: -自适应尺寸label
    convenience init(text: String?, font: UIFont!, tColor: UIColor!, alignment: NSTextAlignment, numberOfLines: Int) {
    
        self.init(frame: CGRect.zero, text: text, font: font, tColor: tColor, alignment: alignment, numberOfLines: numberOfLines)
        
        self.sizeToFit()
    }
    // MARK: -给定frame的label
    convenience init(frame: CGRect, text: String?, font: UIFont!, tColor: UIColor!, alignment: NSTextAlignment, numberOfLines: Int) {
        
        self.init(frame: frame)
        
        self.text = text
        
        self.font = font
        
        self.textColor = tColor
        
        self.textAlignment = alignment
        
        self.numberOfLines = numberOfLines
    }
}
