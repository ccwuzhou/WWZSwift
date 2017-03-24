//
//  WWZViewController.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

open class WWZViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.edgesForExtendedLayout = .all
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    
    override open var shouldAutorotate: Bool{
    
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    
        return UIInterfaceOrientationMask.portrait
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
    
        return UIInterfaceOrientation.portrait
    }

}
