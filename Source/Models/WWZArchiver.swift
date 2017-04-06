//
//  WWZArchiver.swift
//  WWZSwift
//
//  Created by wwz on 17/3/14.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

class WWZArchiver: NSObject, NSCoding {

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        for children in Mirror(reflecting: self).children {
        
            if let key = children.label {
                
                setValue(aDecoder.decodeObject(forKey: key), forKey: key)
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        for children in Mirror(reflecting: self).children {
            
            if let key = children.label {
                
                aCoder.encode(value(forKey: key), forKey: key)
            }
        }
    }
}


final class PreferenceKey<T>: PreferenceKeys { }

class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}

extension PreferenceKeys {
    static let launchAtLogin = PreferenceKey<Bool>("LaunchAtLogin")
    static let launchCount = PreferenceKey<Int>("LaunchCount")
    static let userInfo = PreferenceKey<WWZArchiver>("UserInfo")
}

let defaultPreferences: [PreferenceKeys: Any] = [
    .launchAtLogin: false,
    .launchCount: 0,
    .userInfo: NSKeyedArchiver.archivedData(withRootObject: WWZArchiver()),
]


let Preferences = PreferenceManager.shared

final class PreferenceManager {
    static let shared = PreferenceManager()
    let defaults = UserDefaults.standard
    
    private init() {
        registerDefaultPreferences()
    }
    
    private func registerDefaultPreferences() {
        // Convert dictionary of type [PreferenceKey: Any] to [String: Any].
        let defaultValues: [String: Any] = defaultPreferences.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        defaults.register(defaults: defaultValues)
    }
}

extension PreferenceManager {
    subscript(key: PreferenceKey<Any>) -> Any? {
        get { return defaults.object(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<URL>) -> URL? {
        get { return defaults.url(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[Any]>) -> [Any]? {
        get { return defaults.array(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String: Any]>) -> [String: Any]? {
        get { return defaults.dictionary(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<String>) -> String? {
        get { return defaults.string(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<[String]>) -> [String]? {
        get { return defaults.stringArray(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Data>) -> Data? {
        get { return defaults.data(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Bool>) -> Bool {
        get { return defaults.bool(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Int>) -> Int {
        get { return defaults.integer(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Float>) -> Float {
        get { return defaults.float(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<Double>) -> Double {
        get { return defaults.double(forKey: key.rawValue) }
        set { defaults.set(newValue, forKey: key.rawValue) }
    }
    
    subscript(key: PreferenceKey<WWZArchiver>) -> WWZArchiver? {
        get {
            var object: WWZArchiver?
            if let data = defaults.data(forKey: key.rawValue) {
                object = NSKeyedUnarchiver.unarchiveObject(with: data) as? WWZArchiver
            }
            return object
        }
        set {
            if let object = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: object)
                defaults.set(data, forKey: key.rawValue)
            }
        }
    }
}
