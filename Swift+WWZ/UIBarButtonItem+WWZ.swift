//
//  UIBarButtonItem-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/26.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    convenience init(imageName: String) {
        
        self.init(nImageName: imageName, hImageName: imageName + "_highlighted")
    }
    
    convenience init(nImageName: String, hImageName: String) {
        
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: nImageName), for: .normal)
        leftBtn.setImage(UIImage(named: hImageName), for: .highlighted)
        leftBtn.sizeToFit()
        
        self.init(customView: leftBtn)
    }
}
