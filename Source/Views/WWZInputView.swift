
//
//  WWZInputView.swift
//  wwz_swift
//
//  Created by wwz on 17/3/3.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

fileprivate let INPUT_LINE_COLOR = UIColor.colorFromRGBA(204, 204, 204, 1)
fileprivate let INPUT_BUTTON_TAG = 99
fileprivate let INPUT_BUTTON_HEIGHT : CGFloat = 45.0

open class WWZInputView: WWZShowView {

    // MARK: -私有属性
    fileprivate var block : ((String, Int)->())?
    
    fileprivate lazy var inputTextField : UITextField = {
    
        let textFieldX : CGFloat = 20.0
        let textField = UITextField(frame: CGRect(x: textFieldX, y: 0, width: self.width-textFieldX*2, height: 40), placeholder: nil, font: UIFont.systemFont(ofSize: 14))
        textField.delegate = self
        
        return textField
    }()
    
    public init(title: String, text: String?, placeHolder: String?, buttonTitles: [String], clickButtonAtIndex block: @escaping (_ inputText: String,_ index: Int)->()) {
        
        let inputViewW : CGFloat = WWZ_IsPad ? 425 : WWZ_SCREEN_WIDTH * 250.0/320.0
        let inputViewH : CGFloat = WWZ_IsPad ? 183 : 150
        
        super.init(frame: CGRect(x: (WWZ_SCREEN_WIDTH-inputViewW)*0.5, y: WWZ_SCREEN_HEIGHT*0.25, width: inputViewW, height: inputViewH))
        
        guard buttonTitles.count != 2 else {
            
            return
        }
        self.backgroundColor = UIColor.white
        
        self.block = block
        
        self.layer.wwz_setCorner(radius: 15)
        
        let spaceY : CGFloat = WWZ_IsPad ? 20 : 15
        
        // title label
        let titleLabel = UILabel(text: title, font: UIFont.boldSystemFont(ofSize: 20), tColor: UIColor.black, alignment: .center, numberOfLines: 1)
        titleLabel.y = spaceY
        titleLabel.x = (self.width-titleLabel.width)*0.5
        self.addSubview(titleLabel)
        
        // textField
        self.inputTextField.y = titleLabel.bottom + spaceY
        self.inputTextField.placeholder = placeHolder
        self.inputTextField.text = text
        self.addSubview(self.inputTextField)
        
        // buttons
        self.p_addBottomButtons(buttonTitles: buttonTitles)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WWZInputView : UITextFieldDelegate{

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
extension WWZInputView {

    // MARK: -添加按钮
    fileprivate func p_addBottomButtons(buttonTitles: [String]) {
        
        for buttonTitle in buttonTitles {
            
            let index = buttonTitles.index(of: buttonTitle)!
            
            let rect = CGRect(x: 0+CGFloat(index)*self.width/CGFloat(buttonTitles.count), y: self.height-INPUT_BUTTON_HEIGHT, width: self.width/CGFloat(buttonTitles.count), height: INPUT_BUTTON_HEIGHT)
            
            self.addSubview(self.p_bottomButton(frame: rect, title: buttonTitle, tag: index))
            
            if index == 1 {
                
                let lineView = UIView(frame:  CGRect(x: self.width*0.5-0.25, y: self.height-INPUT_BUTTON_HEIGHT, width: 0.5, height: INPUT_BUTTON_HEIGHT), backgroundColor: INPUT_LINE_COLOR)
                self.addSubview(lineView)
            }
        }
    }
    
    fileprivate func p_bottomButton(frame: CGRect, title: String, tag: Int) -> UIButton {
        
        let btn = UIButton(frame: frame, nTitle: title, titleFont: UIFont.systemFont(ofSize: 16), nColor: UIColor.black)

        btn.setBackgroundImage(UIImage.wwz_image(color: INPUT_LINE_COLOR, size: frame.size), for: .highlighted)

        btn.tag = INPUT_BUTTON_TAG + tag
        btn.addTarget(self, action: #selector(self.clickButtonAtIndex), for: .touchUpInside)
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 0.5), backgroundColor: INPUT_LINE_COLOR)

        btn.addSubview(lineView)
        return btn
    }
    
    @objc private func clickButtonAtIndex(sender: UIButton) {
        
        if let block = self.block {
            
            block(self.inputTextField.text ?? "", sender.tag - INPUT_BUTTON_TAG)
        }
        self.wwz_dismiss(completion: nil)
    }
    
    public override func wwz_show(completion: ((Bool) -> ())?) {
        self.inputTextField.becomeFirstResponder()
        super.wwz_show(completion: completion)
    }
    
    public override func wwz_dismiss(completion: ((Bool) -> ())?) {
        self.inputTextField.resignFirstResponder()
        super.wwz_dismiss(completion: completion)
    }
}
