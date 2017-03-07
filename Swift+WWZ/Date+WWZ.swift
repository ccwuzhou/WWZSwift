//
//  Date+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/7.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

extension Date {
    
    static func wwz_stringFromDate(date: Date, dateFormat: String!) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    static func wwz_timeStamp() -> String {
        
        return "\(Int(Date().timeIntervalSince1970))"
    }
}
