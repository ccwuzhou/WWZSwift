//
//  UINavigationBar+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/8.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func wwz_setTitle(color: UIColor, font: UIFont) {
        
        self.titleTextAttributes = [NSForegroundColorAttributeName:color,NSFontAttributeName:font]
    }
    
    func wwz_noShadowImage() {
        
        guard self.responds(to: #selector(UINavigationBar.setBackgroundImage(_:for:barMetrics:))) else { return }
        
        for obj in self.subviews {
            
            if Float(UIDevice.current.systemVersion)! >= Float(10.0) {
                
                for obj2 in obj.subviews {
                    
                    if let imageView = obj2 as? UIImageView {
                    
                        imageView.isHidden = true
                    }
                }
            }else{
                
                if let imageView = obj as? UIImageView {
                    
                    for obj2 in imageView.subviews {
                        
                        if let imageView = obj2 as? UIImageView {
                            
                            imageView.isHidden = true
                        }
                    }
                }
            }
        }
    }
}
