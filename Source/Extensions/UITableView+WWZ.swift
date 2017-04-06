//
//  UITableView.swift
//  WWZSwift
//
//  Created by wwz on 17/3/8.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UITableView {

    public convenience init(frame: CGRect, dataSource: UITableViewDataSource?, delegate: UITableViewDelegate?) {
        
        self.init(frame: frame)
        self.dataSource = dataSource
        self.delegate = delegate
        self.separatorStyle = .none
    }
}
