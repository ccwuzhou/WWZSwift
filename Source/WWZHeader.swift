//
//  WWZHeader.swift
//  wwz_swift
//
//  Created by wwz on 17/2/24.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public typealias JSONDictionary = [String: Any]

let APP_WINDOW = UIApplication.shared.keyWindow
// 屏幕宽度
let SCREEN_HEIGHT = UIScreen.main.bounds.height
// 屏幕高度
let SCREEN_WIDTH = UIScreen.main.bounds.width

let NAVBAR_HEIGHT : CGFloat = 64.0

let TABBAR_HEIGHT : CGFloat = 49.0

let CELL_IDENTIFIER = "CELL_IDENTIFIER"

// 系统
let SYSTEM_VERSION = UIDevice.current.systemVersion

let isIOS7Later = SYSTEM_VERSION.compare("7.0") != ComparisonResult.orderedAscending
let isIOS8Later = SYSTEM_VERSION.compare("8.0") != ComparisonResult.orderedAscending
let isIOS9Later = SYSTEM_VERSION.compare("9.0") != ComparisonResult.orderedAscending
let isIOS10Later = SYSTEM_VERSION.compare("10.0") != ComparisonResult.orderedAscending

// 型号
let isIPhone35Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 640, height: 960))
let isIPhone4Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 640, height: 1136))
let isIPhone47Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 750, height: 1334))
let isIPhone55Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 1242, height: 2208))

let identifierForVendor = UIDevice.current.identifierForVendor

let isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone

let isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

let kNavBgColor = UIColor.colorFromRGBA(36, 46, 51, 1)
let kDefaultBgColor = UIColor.colorFromRGBA(242, 242, 242, 1)
let kDefaultThemeColor = UIColor.colorFromRGBA(51, 184, 252, 1)
let kDefaultTitleColor = UIColor.colorFromRGBA(51, 51, 51, 1)
let kDefaultSubTitleColor = UIColor.colorFromRGBA(153, 153, 153, 1)


//获取本地存储数据
func kGetObjectUserDefaults(key: String) -> Any?{
    
    return UserDefaults.standard.object(forKey: key)
}
//存储数据
func kSaveObjectUserDefaults(key: String, value: Any?){
    
    UserDefaults.standard.set(value, forKey: key)
}
//字符串转数组
func kStringToArray(str: String) -> Array<String> {
    
    var dataArray = [String]()
    
    for items in str.characters{
        dataArray.append("\(items)")
    }
    return dataArray
}



public func WWZLog<T>(_ message: T,file: String = #file, function: String = #function, line: Int = #line){
    
    #if DEBUG
    
        print("\(Date.wwz_stringFromDate(date: Date(), dateFormat: "yyyy-MM-dd HH:mm:ss.SSS")) \((file as NSString).lastPathComponent)【\(function)】\(message)")
        
    #endif
}
