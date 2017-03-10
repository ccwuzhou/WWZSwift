//
//  WWZHeader.swift
//  wwz_swift
//
//  Created by wwz on 17/2/24.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public typealias JSONDictionary = [String: Any]

public let WWZ_APP_WINDOW = UIApplication.shared.keyWindow
// 屏幕宽度
public let WWZ_SCREEN_HEIGHT = UIScreen.main.bounds.height
// 屏幕高度
public let WWZ_SCREEN_WIDTH = UIScreen.main.bounds.width

public let WWZ_NAVBAR_HEIGHT : CGFloat = 64.0

public let WWZ_TABBAR_HEIGHT : CGFloat = 49.0

public let WWZ_CELL_IDENTIFIER = "WWZ_CELL_IDENTIFIER"

// 系统
public let WWZ_SYSTEM_VERSION = UIDevice.current.systemVersion

public let WWZ_IsIOS7Later = WWZ_SYSTEM_VERSION.compare("7.0") != ComparisonResult.orderedAscending
public let WWZ_IsIOS8Later = WWZ_SYSTEM_VERSION.compare("8.0") != ComparisonResult.orderedAscending
public let WWZ_IsIOS9Later = WWZ_SYSTEM_VERSION.compare("9.0") != ComparisonResult.orderedAscending
public let WWZ_IsIOS10Later = WWZ_SYSTEM_VERSION.compare("10.0") != ComparisonResult.orderedAscending

// 型号
public let WWZ_IsIPhone35Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 640, height: 960))
public let WWZ_IsIPhone4Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 640, height: 1136))
public let WWZ_IsIPhone47Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 750, height: 1334))
public let WWZ_IsIPhone55Inch = UIScreen.main.currentMode?.size.equalTo(CGSize(width: 1242, height: 2208))

public let WWZ_IsPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone

public let WWZ_IsPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

// 打印，复制到项目中
/*
public func WWZLog<T>(_ message: T,file: String = #file, function: String = #function, line: Int = #line){
    
    #if DEBUG
    
        print("\(Date.wwz_stringFromDate(date: Date(), dateFormat: "yyyy-MM-dd HH:mm:ss.SSS")) \((file as NSString).lastPathComponent)【\(function)】\(message)")
        
    #endif
}
 */
