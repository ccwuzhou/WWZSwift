//
//  WWZViewController.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

class WWZViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
    override var shouldAutorotate: Bool{
    
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
    
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
    
        return UIInterfaceOrientation.portrait
    }

}
