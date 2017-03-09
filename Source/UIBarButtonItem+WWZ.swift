//
//  UIBarButtonItem-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/26.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {

    public convenience init(imageName: String) {
        
        self.init(nImageName: imageName, hImageName: imageName + "_highlighted")
    }
    
    public convenience init(nImageName: String, hImageName: String) {
        
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: nImageName), for: .normal)
        leftBtn.setImage(UIImage(named: hImageName), for: .highlighted)
        leftBtn.sizeToFit()
        
        self.init(customView: leftBtn)
    }
    
    public convenience init(nImageName: String, sImageName: String) {
        
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: nImageName), for: .normal)
        leftBtn.setImage(UIImage(named: sImageName), for: .selected)
        leftBtn.sizeToFit()
        
        self.init(customView: leftBtn)
    }
}
