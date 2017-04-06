//
//  String+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/7.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     *  MD5加密
     */
    /*
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
     */
    /**
     *  得到十六进制字符
     */
    public var wwz_sixteenthTypeString : String {
        
        if let intValue = Int(self) {
            
            return String().appendingFormat("%x", intValue)
        }else{
            
            return "0"
        }
    }
    
    public var wwz_tenTypeValue : Int {
        
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
    public static func wwz_filePath(fileName: String) -> String {
        
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
    public func wwz_fixedString(length: Int) -> String {
        
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
    
    public func stringArray() -> [String] {
        
        var dataArray = [String]()
        
        for item in self.characters {
            
            dataArray.append("\(item)")
        }
        return dataArray
    }
    
    // MARK: -下标扩展
    /// 获取单
    public subscript(n: Int) -> Character?{
        
        guard n < self.characters.count, n >= 0 else {
            
            return nil
        }
        
        let index = self.characters.index(self.characters.startIndex, offsetBy:n)
        
        return self.characters[index]
    }
    
    // 从0开始的close range
    public subscript (range: CountableClosedRange<Int>) -> String{
        
        get {
            if range.lowerBound >= self.characters.count { return "" }
            
            let startIndex = range.lowerBound <= 0 ? self.startIndex : self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = range.upperBound < self.characters.count ? self.index(self.startIndex, offsetBy: range.upperBound) : self.endIndex
            
            return self.substring(with: startIndex..<endIndex)
        }
    }
}

extension String {
    
    public func wwz_jsonFormat() -> String {
        
        let spacing = "\t"
        let enterKey = "\n"
        
        var number = 0
        
        let addSpaceBlock : (Int)-> String = { num in
            
            var mString = String()
            
            for _ in 0..<num {
                mString.append(spacing)
            }
            return mString
        }
        
        let firstCharacter = self[0...1]
        
        var mString = "\n" + firstCharacter
        
        if firstCharacter == "[" || firstCharacter == "{" {
            
            mString.append(enterKey)
            
            number += 1
            
            mString.append(addSpaceBlock(number))
        }
        
        var isInQuotation = false
        
        for i in 0...self.characters.count {
            
            let subC = self[i...i+1]
            
            if subC == "\"" && self[i-1...i] != "\\" {
                
                isInQuotation = !isInQuotation
            }
            
            if isInQuotation {
                
                mString.append(subC)
                continue
            }
            
            if subC == "[" || subC == "{" {
                
                if self[i-1...i] == ":" {
                    
                    mString.append(enterKey)
                    mString.append(addSpaceBlock(number))
                }
                
                mString.append(subC+enterKey)
                
                number += 1
                
                mString.append(addSpaceBlock(number))
                
            }else if subC == "]" || subC == "}" {
                
                mString.append(enterKey)
                
                number -= 1
                
                mString.append(addSpaceBlock(number))
                
                mString.append(subC)
                
                if i+1 < self.characters.count && self[i+1...i+2] != "," {
                    mString.append(enterKey)
                }
            }else if subC == "," {
                
                mString.append(subC)
                
                mString.append(enterKey)
                
                mString.append(addSpaceBlock(number))
                
            }else {
                
                mString.append(subC)
                
            }
        }
        
        return mString
    }
}

