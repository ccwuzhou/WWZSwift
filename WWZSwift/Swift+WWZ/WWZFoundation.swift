//
//  WWZFoundation.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

extension String {
    
    /**
     *  MD5加密
     */
    var md5 : String {
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = (CC_LONG)(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var hash = String()
        
        for i in 0 ..< digestLen {
            hash = hash.appendingFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return hash
    }
    
    /**
     *  得到十六进制字符
     */
    var wwz_sixteenthTypeString : String {
        
        if let intValue = Int(self) {
            
            return String().appendingFormat("%x", intValue)
        }else{
            
            return "0"
        }
    }
    
    var wwz_tenTypeValue : Int {
        
        let str = self.uppercased()
        var number = 0
        
        for i in str.utf8 {
            number = number * 16 + Int(i) - 48
            
            if i >= 65 {
                
                number -= 7
            }
        }
        return number
    }
    
    /**
     *  NSDocumentDirectory 中文件路径
     */
    static func wwz_filePath(fileName: String) -> String {
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        return documentPath.appending("/\(fileName)")
    }
    /**
     *  指定长度字符串（从后面截取）
     *
     *  @param length 截取长度
     *
     *  @return 指定长度字符串，不足前面补0
     */
    func wwz_fixedString(length: Int) -> String {
        
        let strLength = self.characters.count
        
        if strLength >= length {
            
            return self.substring(from: self.index(self.startIndex, offsetBy: strLength - length))
        }else{
            
            var mString = self
            
            for _ in 0..<length-strLength {
                
                mString = "0\(mString)"
            }
            
            return mString
        }
    }
    
    // MARK: -下标扩展
    /// 获取单
    subscript(n: Int) -> Character?{
        
        guard n < self.characters.count, n >= 0 else {
        
            return nil
        }
        
        let index = self.characters.index(self.characters.startIndex, offsetBy:n)
        
        return self.characters[index]
    }
    
    // 从0开始的close range
    subscript (range: CountableClosedRange<Int>) -> String{
        
        get {
            if range.lowerBound >= self.characters.count { return "" }
            
            let startIndex = range.lowerBound <= 0 ? self.startIndex : self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = range.upperBound < self.characters.count ? self.index(self.startIndex, offsetBy: range.upperBound+1) : self.endIndex
            
            return self.substring(with: startIndex..<endIndex)
        }
    }
}

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

extension NotificationCenter {
    
    static func wwz_addObserver(_ observer: Any, selector: Selector, name: String) {
        
        self.default.addObserver(observer, selector: selector, name: NSNotification.Name(name), object: nil)
    }
    static func wwz_post(name: String, object: Any?){
        
        self.default.post(name: NSNotification.Name(name), object: object)
    }
    
    static func wwz_post(name: String, object: Any?, userInfo:[AnyHashable : Any]?){
        
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
