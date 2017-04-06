//
//  WWZSwiftTests.swift
//  WWZSwiftTests
//
//  Created by wwz on 17/3/22.
//  Copyright © 2017年 tijio. All rights reserved.
//

import XCTest
import WWZSwift
class WWZSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let str = "wwz"[0...2]
        WWZ_DEBUG_ENABLED = true
        
        WWZLog(WWZLanguage.shared.currentLanguageValue)
        
        
        WWZLog(str)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
