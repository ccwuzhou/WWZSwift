//
//  ViewController.swift
//  Example
//
//  Created by wwz on 17/3/10.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit
import WWZSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WWZ_DEBUG_ENABLED = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        WWZLog("")
        
    }
}

