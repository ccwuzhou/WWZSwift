//
//  Date+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/7.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

public extension Date {
    
    /// 格式化date
    public func wwz_dateFormatString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
    
    /// Date => DateComponents
    public func wwz_dateComponents() -> DateComponents {
        
        let calendarSet : Set<Calendar.Component> = [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second]
        
        return Calendar.current.dateComponents(calendarSet, from: self)
    }
    
    /// 时间截
    public static func wwz_timeStamp() -> String {
        
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    public init (_ timestamp: TimeInterval){
        
        self.init(timeIntervalSince1970: timestamp)
    }
    
}
