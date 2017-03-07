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
fileprivate let TIP_TITLE_LABEL_X : CGFloat = 20.0
fileprivate var TIP_TITLE_LABEL_Y : CGFloat = 20.0



fileprivate let TIP_BUTTON_HEIGHT : CGFloat = 45.0


class WWZTipView: WWZShowView {
    
    // MARK: -私有属性
    fileprivate var block : ((Int)->())?
    
    fileprivate var mAttributedString : NSMutableAttributedString?
    
    fileprivate lazy var mParagraphStyle : NSMutableParagraphStyle = {
        
        let style = NSMutableParagraphStyle()
        
        style.firstLineHeadIndent = 0
        style.alignment = .center
        style.lineSpacing = 5
    
        return style
    }()
    
    fileprivate lazy var titleLabel : UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: -设置方法
    var titleColor : UIColor = UIColor.black {
    
        didSet {
        
            self.mAttributedString?.addAttributes([NSForegroundColorAttributeName : titleColor], range: NSRange(location: 0, length: self.mAttributedString!.string.characters.count))
            self.titleLabel.attributedText = self.mAttributedString
        }
    }
    
    var buttonTitleColor : UIColor = UIColor.black {
    
        didSet {
        
            for subView in self.subviews {
                
                if let subView = subView as? UIButton {
                
                    subView.setTitleColor(buttonTitleColor, for: .normal)
                }
            }
        }
    }
    var buttonTitleFont : UIFont = UIFont.systemFont(ofSize: 16) {
        
        didSet {
            
            for subView in self.subviews {
                
                if let button = subView as? UIButton {
                    
                    button.titleLabel?.font = buttonTitleFont
                }
            }
        }
    }
    
    
    convenience init(title: String, font: UIFont, lineSpace: CGFloat, buttonTitles: [String], clickButtonAtIndex block: @escaping (_ index: Int)->()) {
        
        self.init(frame: CGRect.zero)
        
        if buttonTitles.count == 0 || buttonTitles.count > 2 {
            return
        }
        
        self.block = block
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
        
        self.backgroundColor = UIColor.white
        
        let screenSize = UIScreen.main.bounds.size
        
        if screenSize.width == 320 {
            
            self.x = 30
        }else if screenSize.width == 375 {
            
            self.x = 45
        }else{
            
            self.x = 60
        }
        
        self.width = screenSize.width - 2*self.x
        
        // title label
        self.p_addTitleLabel(title: title, font: font, lineSpace: lineSpace)
    
        
        self.height = 2 * TIP_TITLE_LABEL_Y + self.titleLabel.height + TIP_BUTTON_HEIGHT
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
    fileprivate func p_addTitleLabel(title: String, font: UIFont, lineSpace: CGFloat) {
    
        self.mParagraphStyle.lineSpacing = lineSpace
        
        self.mAttributedString = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: self.titleColor, NSParagraphStyleAttributeName: self.mParagraphStyle])
        
        self.titleLabel.attributedText = self.mAttributedString
        
        let titleLW = self.width-TIP_TITLE_LABEL_X*2
        
        let titleLH = self.titleLabel.textRect(forBounds: CGRect(x: 0.0, y: 0.0, width: titleLW, height: 500), limitedToNumberOfLines: 0).size.height
        
        TIP_TITLE_LABEL_Y = titleLH < 30 ? TIP_TITLE_LABEL_Y + 2.5 : TIP_TITLE_LABEL_Y;
        
        self.titleLabel.frame = CGRect(x: TIP_TITLE_LABEL_X, y: TIP_TITLE_LABEL_Y, width: titleLW, height: titleLH)

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
        self.wwz_dismiss()
    }
}
