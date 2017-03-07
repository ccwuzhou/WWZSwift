//
//  UIButton-WWZ.swift
//  webo_swift
//
//  Created by wwz on 17/2/24.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

extension UIButton {
    
    /**
     设置title
     */
    func wwz_setTitle(nTitle: String?) {
        self.setTitle(nTitle, for: .normal)
    }
    func wwz_setTitle(nTitle: String?, sTitle: String?) {
        self.setTitle(nTitle, for: .normal)
        self.setTitle(sTitle, for: .selected)
    }
    /**
     设置title color
     */
    func wwz_setTitleColor(nColor: UIColor?) {
        self.setTitleColor(nColor, for: .normal)
    }
    func wwz_setTitleColor(sColor: UIColor?) {
        self.setTitleColor(sColor, for: .selected)
    }
    func wwz_setTitleColor(nColor: UIColor?, hColor: UIColor?) {
        self.setTitleColor(nColor, for: .normal)
        self.setTitleColor(hColor, for: .highlighted)
    }
    func wwz_setTitleColor(nColor: UIColor?, sColor: UIColor?) {
        self.setTitleColor(nColor, for: .normal)
        self.setTitleColor(sColor, for: .selected)
    }
    func wwz_setTitleColor(nColor: UIColor?, hColor: UIColor?, sColor: UIColor?) {
        self.setTitleColor(nColor, for: .normal)
        self.setTitleColor(hColor, for: .highlighted)
        self.setTitleColor(sColor, for: .selected)
    }
    /**
     设置image
     */
    public func wwz_setNImage(_ nImage: String?, hImage: String?, sImage: String?) {
        
        if let nImage = nImage {
            self.setImage(UIImage(named: nImage), for: .normal)
        }
        if let hImage = hImage {
            self.setImage(UIImage(named: hImage), for: .highlighted)
        }
        if let sImage = sImage {
            self.setImage(UIImage(named: sImage), for: .selected)
        }
    }
    
    /**
     设置image
     */
    public func wwz_setNBImage(_ nBImage: String?, hBImage: String?, sBImage: String?) {
        
        if let nBImage = nBImage {
            self.setBackgroundImage(UIImage(named: nBImage), for: .normal)
        }
        if let hBImage = hBImage {
            self.setBackgroundImage(UIImage(named: hBImage), for: .highlighted)
        }
        if let sBImage = sBImage {
            self.setBackgroundImage(UIImage(named: sBImage), for: .selected)
        }
    }
    /**
     方法
     */
    public func wwz_setTarget(_ target: AnyObject?, action: Selector) {
        
        self.addTarget(target, action: action, for: .touchUpInside);
    }
    
    /**
     左右间隔
     */
    public func wwz_setLeftRightInset(_ inset: CGFloat) {
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, inset);
    }
    // MARK: -只有图标
    convenience init(nImageName: String?) {
        
        self.init(nImageName: nImageName, hImageName: nil, sImageName: nil);
    }
    convenience init(nImageName: String?, hImageName: String?) {

        self.init(nImageName: nImageName, hImageName: hImageName, sImageName: nil);
    }
    convenience init(nImageName: String?, sImageName: String?) {
        
        self.init(nImageName: nImageName, hImageName: nil, sImageName: sImageName);
    }
    convenience init(nImageName: String?, hImageName: String?, sImageName: String?) {
        
        self.init(nImageName: nImageName, hImageName: hImageName, sImageName: sImageName, nBImageName: nil, hBImageName: nil, sBImageName: nil)
    }
    // MARK: -图标与背景图标
    convenience init(nImageName: String?, nBImageName: String?) {
        
        self.init(nImageName: nImageName, hImageName: nil, sImageName: nil, nBImageName: nBImageName, hBImageName: nil, sBImageName: nil)
    }
    convenience init(nImageName: String?, hImageName: String?, nBImageName: String?, hBImageName: String?) {
        
         self.init(nImageName: nImageName, hImageName: hImageName, sImageName: nil, nBImageName: nBImageName, hBImageName: hBImageName, sBImageName: nil)
    }
    convenience init(nImageName: String?, sImageName: String?, nBImageName: String?, sBImageName: String?) {
        
        self.init(nImageName: nImageName, hImageName: nil, sImageName: sImageName, nBImageName: nBImageName, hBImageName: nil, sBImageName: sBImageName)
    }
    convenience init(nImageName: String?, hImageName: String?, sImageName: String?, nBImageName: String?, hBImageName: String?, sBImageName: String?) {
        
        self.init()

        if let nImageName = nImageName {
            self.setImage(UIImage(named: nImageName), for: .normal)
        }
        
        if let hImageName = hImageName {
            self.setImage(UIImage(named: hImageName), for: .highlighted)
        }
        
        if let sImageName = sImageName {
            self.setImage(UIImage(named: sImageName), for: .selected)
        }
        
        if let nBImageName = nBImageName {
            self.setBackgroundImage(UIImage(named: nBImageName), for: .normal)
        }
        
        if let hBImageName = hBImageName {
            self.setBackgroundImage(UIImage(named: hBImageName), for: .highlighted)
        }
        
        if let sBImageName = sBImageName {
            self.setBackgroundImage(UIImage(named: sBImageName), for: .selected)
        }
        self.sizeToFit()
    }
    
    // MARK: -文字(正常)
    convenience init(frame: CGRect, nTitle: String?, titleFont: UIFont!, nColor: UIColor?) {
    
        self.init(frame: frame, nTitle: nTitle, sTitle: nil, titleFont: titleFont, nColor: nColor, sColor: nil, nImageName: nil, sImageName: nil)
    }
    // MARK: -文字(正常与选中)
    convenience init(frame: CGRect, nTitle: String?, sTitle: String?, titleFont: UIFont!, nColor: UIColor?, sColor: UIColor?) {
        
        self.init(frame: frame, nTitle: nTitle, sTitle: sTitle, titleFont: titleFont, nColor: nColor, sColor: sColor, nImageName: nil, sImageName: nil)
    }
    // MARK: -图标与文字
    convenience init(frame: CGRect, nTitle: String?, sTitle: String?, titleFont: UIFont!, nColor: UIColor?, sColor: UIColor?, nImageName: String?, sImageName: String?) {
        
        self.init()
        
        self.setTitle(nTitle, for: .normal)
        self.setTitle(sTitle, for: .selected)
        
        self.titleLabel?.font = titleFont;
        
        self.setTitleColor(nColor, for: .normal)
        self.setTitleColor(sColor, for: .selected)
        
        if let nImageName = nImageName {
            self.setImage(UIImage(named: nImageName), for: .normal)
        }
        
        if let sImageName = sImageName {
            self.setImage(UIImage(named: sImageName), for: .selected)
        }
        
        if frame.equalTo(CGRect.zero) {
            
            self.sizeToFit()
        }else{
        
            self.frame = frame;
        }
    }
}
