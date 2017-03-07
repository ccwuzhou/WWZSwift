//
//  UITextField-WWZ.swift
//  wwz_swift
//
//  Created by wwz on 17/3/3.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UITextField {

    convenience init(frame: CGRect, placeholder: String?, font: UIFont?) {
        
        self.init(frame: frame)
        
        self.returnKeyType = .done
        self.borderStyle = .roundedRect
        self.font = font
        self.placeholder = placeholder
    }
}
