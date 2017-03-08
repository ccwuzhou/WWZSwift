//
//  WWZShowView.swift
//  wwz_swift
//
//  Created by wwz on 17/3/2.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

enum WWZShowViewAnimateType {
    
    case alpha
    case fromTop
    case fromLeft
    case fromRight
    case fromBottom
}

class WWZShowView: UIView {

    // MARK: -属性
    var animateType : WWZShowViewAnimateType = .alpha
    
    var animateDuration : TimeInterval = 0.3
    
    var backColor : UIColor = UIColor(white: 0, alpha: 0.1)
    // 点击空白区域消失
    var isTapEnabled : Bool = true
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.animateType = .alpha
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        self.p_originalTransform(type: self.animateType)
        
        UIView.animate(withDuration: self.animateDuration, animations: {
            
            self.p_endTransform(type: self.animateType)
            
        }, completion: completion)
    }
    
    /// 隐藏
    func wwz_dismiss(completion: ((_ finished: Bool)->())?){
        
        UIView.animate(withDuration: self.animateDuration, animations: {
            
            self.p_originalTransform(type: self.animateType)
            
            }, completion: {(_ finished: Bool) -> Void in
                
                self.superview?.removeFromSuperview()
                self.removeFromSuperview()
                
                if let completion = completion {
                
                    completion(finished)
                }
        })
    }
    
    
//    deinit {
//        WWZLog("")
//    }
}
// MARK: -私有方法
extension WWZShowView {

    fileprivate func p_originalTransform(type: WWZShowViewAnimateType) {
        
        self.superview?.alpha = 0
        
        switch type {
            
        case .alpha:
            self.alpha = 0
        case .fromTop:
            self.transform = CGAffineTransform(translationX: 0, y: -self.height)
        case .fromLeft:
            self.transform = CGAffineTransform(translationX: -self.width, y: 0)
        case .fromBottom:
            self.transform = CGAffineTransform(translationX: 0, y: self.superview!.height)
        case .fromRight:
            self.transform = CGAffineTransform(translationX: self.superview!.width, y: 0)
        }
    }
    
    fileprivate func p_endTransform(type: WWZShowViewAnimateType) {
        
        self.superview?.alpha = 1
        
        switch type {
            
        case .alpha:
            self.alpha = 1
        case .fromTop, .fromLeft, .fromBottom, .fromRight:
            self.transform = CGAffineTransform.identity
        }
    }
}

