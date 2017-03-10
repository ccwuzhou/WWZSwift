//
//  UIAlertController+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/10.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UIAlertController {

    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttonTitles: [String], clickButtonAtIndexBlock block: ((_ index: Int)->())?) {
        
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        
        for title in buttonTitles {
            
            let index = buttonTitles.index(of: title)!
            
            let style : UIAlertActionStyle = (index == 0 ? .cancel : .default)
            
            let action = UIAlertAction(title: title, style: style) { (_) in
                
                if let block = block {
                    
                    block(index)
                }
            }
            self.addAction(action)
        }
    }
}
