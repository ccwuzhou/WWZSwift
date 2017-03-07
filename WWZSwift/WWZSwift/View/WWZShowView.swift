//
//  WWZShowView.swift
//  wwz_swift
//
//  Created by wwz on 17/3/2.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

enum WWZShowType {
    
    case none
    case top
    case left
    case right
    case bottom
}

private let ANIMATION_DURATION : TimeInterval = 0.3

class WWZShowView: UIView {

    // MARK: -属性
    var showType : WWZShowType = .none
    
    // 点击空白区域消失
    var isTapEnabled : Bool = true
    
    convenience init(frame: CGRect, showType: WWZShowType) {
        
        self.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.showType = showType
    }

    // MARK: -显示
    func wwz_show(completion: ((_ finished: Bool)->())?) {
        
        let containButton = UIButton(frame: UIScreen.main.bounds)
        containButton.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, 0.1)
        
        if self.isTapEnabled {
            containButton.addTarget(self, action: #selector(self.wwz_dismiss), for: .touchUpInside)
        }
        containButton.addSubview(self)
        
        // 添加到window上
        UIApplication.shared.keyWindow?.addSubview(containButton)
        
        self.p_originalTransform(type: self.showType)
        
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            
            self.p_endTransform(type: self.showType)
            
        }, completion: completion)
    }
    
    /// 隐藏
    func wwz_dismiss(){
        
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            
            self.p_originalTransform(type: self.showType)
            
            }, completion: {(_ finished: Bool) -> Void in
                
                self.superview?.removeFromSuperview()
                self.removeFromSuperview()
        })
    }
    
    
//    deinit {
//        WWZLog("")
//    }
}
// MARK: -私有方法
extension WWZShowView {

    fileprivate func p_originalTransform(type: WWZShowType) {
        
        self.superview?.alpha = 0
        
        switch type {
            
        case .none:
            self.alpha = 0
        case .top:
            self.transform = CGAffineTransform(translationX: 0, y: -self.height)
        case .left:
            self.transform = CGAffineTransform(translationX: -self.width, y: 0)
        case .bottom:
            self.transform = CGAffineTransform(translationX: 0, y: self.superview!.height)
        case .right:
            self.transform = CGAffineTransform(translationX: self.superview!.width, y: 0)
        }
    }
    
    fileprivate func p_endTransform(type: WWZShowType) {
        
        self.superview?.alpha = 1
        
        switch type {
            
        case .none:
            self.alpha = 1
        case .top, .left, .bottom, .right:
            self.transform = CGAffineTransform.identity
        }
    }
}

