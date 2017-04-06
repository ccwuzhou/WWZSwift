//
//  WWZLanguage.swift
//  WWZSwift
//
//  Created by wwz on 2017/4/6.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

private let WWZ_EN_VALUE = "en"
private let WWZ_ZH_HANS_VALUE = "zh-Hans"
private let WWZ_ZH_HANT_VALUE = "zh-Hant"

public enum WWZLanguageType {

    case english
    case simpleChinese
    case hantChinese
    case other
}

public class WWZLanguage: NSObject {

    public static let shared = WWZLanguage()
    
    /// 当前语言
    public lazy var currentLanguageValue : String = {
    
        guard let languageValues = UserDefaults.standard.object(forKey: "AppleLanguages") as? [String] else { return WWZ_EN_VALUE }
        
        let languageValue = languageValues[0]
        
        if languageValue.hasPrefix(WWZ_ZH_HANS_VALUE) {
        
            return WWZ_ZH_HANS_VALUE
        }
        if languageValue.hasPrefix(WWZ_ZH_HANT_VALUE) {
            
            return WWZ_ZH_HANT_VALUE
        }
        
        return languageValue
    }()
    
    /// 当前语言类型
    public var languageType : WWZLanguageType {
    
        if currentLanguageValue == WWZ_EN_VALUE {
            
            return .english
        }else if currentLanguageValue == WWZ_ZH_HANS_VALUE {
        
            return .simpleChinese
        }else if currentLanguageValue == WWZ_ZH_HANT_VALUE {
        
            return .hantChinese
        }else {
        
            return .other
        }
    }
    
    private lazy var languageBundle : Bundle? = {
    
        if let path = Bundle.main.path(forResource: self.currentLanguageValue, ofType: "lproj") {
        
            return Bundle(path: path)
        }else {
        
            guard let en_path = Bundle.main.path(forResource: WWZ_EN_VALUE, ofType: "lproj") else {
            
                return nil
            }
            
            return Bundle(path: en_path)
        }
    }()
    
    
    public func localizedString(key: String) -> String {
    
        return self.localizedString(key: key, inTable: "Localizable")
    }
    
    public func localizedString(key: String, inTable: String) -> String {
        
        guard let bundle = self.languageBundle else {
            
            return Bundle.main.localizedString(forKey: key, value: "", table: inTable)
        }
        
        return bundle.localizedString(forKey: key, value: "", table: inTable)
    }
}
