//
//  WWZTipView.swift
//  wwz_swift
//
//  Created by wwz on 17/3/1.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

fileprivate let TIP_LINE_COLOR = UIColor.colorFromRGBA(204, 204, 204, 1)
fileprivate let TIP_BUTTON_TAG = 99

fileprivate let TIP_BUTTON_HEIGHT : CGFloat = 45.0

open class WWZTipView: WWZShowView {
    
    // MARK: -私有属性
    fileprivate var block : ((Int)->())?
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: -设置方法
    public var buttonTitleColor : UIColor = UIColor.black {
    
        didSet {
        
            for subView in self.subviews {
                
                if let subView = subView as? UIButton {
                
                    subView.setTitleColor(buttonTitleColor, for: .normal)
                }
            }
        }
    }
    public var buttonTitleFont : UIFont = UIFont.systemFont(ofSize: 16) {
        
        didSet {
            
            for subView in self.subviews {
                
                if let button = subView as? UIButton {
                    
                    button.titleLabel?.font = buttonTitleFont
                }
            }
        }
    }
    
    public convenience init(attributedText: NSAttributedString, buttonTitles: [String], clickButtonAtIndex block: @escaping (_ index: Int)->()) {
        
        let screenSize = UIScreen.main.bounds.size
        var tipViewX : CGFloat = 0;
        if screenSize.width == 320 {
            
            tipViewX = 30
        }else if screenSize.width == 375 {
            
            tipViewX = 45
        }else{
            
            tipViewX = 60
        }

        self.init(frame: CGRect(x: tipViewX, y: 0, width: screenSize.width - 2*tipViewX, height: 0))
        
        if buttonTitles.count == 0 || buttonTitles.count > 2 {
            return
        }
        
        self.block = block
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        
        // title label
        self.p_addTitleLabel(attributedText: attributedText)
    
        self.height = 2 * self.titleLabel.y + self.titleLabel.height + TIP_BUTTON_HEIGHT
        self.y = (screenSize.height-self.height)*0.5
        
        // buttons
        self.p_addBottomButtons(buttonTitles: buttonTitles)
    }
    deinit {
        WWZLog("deinit")
    }
}

extension WWZTipView {
    // MARK: -添加label
    fileprivate func p_addTitleLabel(attributedText: NSAttributedString) {
    
        self.titleLabel.attributedText = attributedText
        
        let titleLabelXY : CGFloat = 20.0
        self.titleLabel.x = titleLabelXY;
        
        self.titleLabel.width = self.width-titleLabelXY*2
        
        self.titleLabel.height = self.titleLabel.textRect(forBounds: CGRect(x: 0.0, y: 0.0, width: self.titleLabel.width, height: 500), limitedToNumberOfLines: 0).size.height
        
        self.titleLabel.y = self.titleLabel.height < 30 ? titleLabelXY + 2.5 : titleLabelXY;
    
        self.addSubview(self.titleLabel)
        
    }
    // MARK: -添加按钮
    fileprivate func p_addBottomButtons(buttonTitles: [String]) {
        
        for buttonTitle in buttonTitles {
            
            let index = buttonTitles.index(of: buttonTitle)!
            
            let rect = CGRect(x: 0+CGFloat(index)*self.width/CGFloat(buttonTitles.count), y: self.height-TIP_BUTTON_HEIGHT, width: self.width/CGFloat(buttonTitles.count), height: TIP_BUTTON_HEIGHT)
            
            self.addSubview(self.p_bottomButton(frame: rect, title: buttonTitle, tag: index))
            
            if index == 1 {
                
                let lineView = UIView(frame:  CGRect(x: self.width*0.5-0.25, y: self.height-TIP_BUTTON_HEIGHT, width: 0.5, height: TIP_BUTTON_HEIGHT), backgroundColor: TIP_LINE_COLOR)
                self.addSubview(lineView)
            }
        }
    }
    
    
    fileprivate func p_bottomButton(frame: CGRect, title: String, tag: Int) -> UIButton {
        
        let btn = UIButton(frame: frame)
        
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(self.buttonTitleColor, for: .normal)
        btn.setBackgroundImage(UIImage.wwz_image(color: TIP_LINE_COLOR, size: frame.size, alpha: 1), for: .highlighted)
        btn.titleLabel?.font = self.buttonTitleFont
        btn.tag = TIP_BUTTON_TAG + tag
        btn.addTarget(self, action: #selector(self.clickButtonAtIndex), for: .touchUpInside)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 0.5))
        lineView.backgroundColor = TIP_LINE_COLOR
        btn.addSubview(lineView)
        return btn
    }
    
    
    @objc private func clickButtonAtIndex(sender: UIButton) {
        
        if let block = self.block {
            
            block(sender.tag - TIP_BUTTON_TAG)
        }
        self.wwz_dismiss(completion: nil)
    }
}
