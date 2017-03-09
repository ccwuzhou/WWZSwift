//
//  WWZFoundation.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    public static func wwz_addObserver(_ observer: Any, selector: Selector, name: String) {
        
        self.default.addObserver(observer, selector: selector, name: NSNotification.Name(name), object: nil)
    }
    public static func wwz_post(name: String, object: Any?){
        
        self.default.post(name: NSNotification.Name(name), object: object)
    }
    
    public static func wwz_post(name: String, object: Any?, userInfo:[AnyHashable : Any]?){
        
        self.default.post(name: NSNotification.Name(name), object: object, userInfo: userInfo)
    }
}

extension Timer {

//    public class func wwz_scheduledTimer(interval: TimeInterval, repeats: Bool, block: ((_ timer : Timer) -> ())) -> Timer{
//        
//        return self.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.p_blockInvoke), userInfo: block, repeats: repeats)
//    }
//    
//    @objc private class func p_blockInvoke(timer: Timer) {
//        
//        if let block = timer.userInfo as? (Timer) -> () {
//        
//            block(timer)
//        }
//    }
    
}
