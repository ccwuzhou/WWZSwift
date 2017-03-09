//
//  WWZUIKit.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit


extension UIAlertView {
    
    // MARK: -代理类
    private class WZAlertViewDelegate : NSObject, UIAlertViewDelegate {
        
        var block : ((_ alert: UIAlertView,_ btnIndex: Int)->Void)?
        
        init(block: ((_ alert: UIAlertView,_ btnIndex: Int)->Void)?) {
            
            super.init()
            
            objc_setAssociatedObject(self, "WZDelegateKey", self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.block = block
        }
        
        fileprivate func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
            if let block = self.block{
                block(alertView, buttonIndex)
            }
        }
    }
    
    
    // MARK: -提示框
    open class func wwz_showTipView(title: String, message: String) {
        
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "确定")
        alert.show()
    }
    
    
    // MARK: -警告框
    /// 警告框 block(确定：1，取消：0)
    open class func wwz_showAlertView(title: String?, message: String?, buttonTitles: [String], clickButtonAtIndexBlock block: ((_ alertView: UIAlertView,_ index: Int)->Void)?) {
        
        guard buttonTitles.count > 0 else {
            return
        }
        
        let cancleTitle = buttonTitles[0]
        
        let delegate = objc_getAssociatedObject(WZAlertViewDelegate(block: block), "WZDelegateKey") as! WZAlertViewDelegate
        
        let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancleTitle)
        
        if buttonTitles.count > 1 {
            
            alert.addButton(withTitle: buttonTitles[1])
        }

        alert.show()
    }
}
