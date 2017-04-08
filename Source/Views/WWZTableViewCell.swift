//
//  WWZTableViewCell.swift
//  wwz_swift
//
//  Created by wwz on 17/2/28.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public enum WWZTableViewCellStyle : Int {
    case none = 0
    case subTitle = 1
    case rightTitle = 2
    case switchView = 4
    case subAndRight = 3
    case subAndSwitch = 5
}

public protocol WWZTableViewCellDelegate: NSObjectProtocol {
    
    func tableViewCell(cell: WWZTableViewCell, didChangedSwitch isOn: Bool)
}

open class WWZTableViewCell: UITableViewCell {

    // MARK: -属性
    public weak var tableViewCellDelegate : WWZTableViewCellDelegate?
    
    /// sub label
    public var subLabel : UILabel?
    
    /// right label
    public var rightLabel : UILabel?
    
    /// switch
    public var mySwitch : UISwitch?
    
    /// text label 与 sub label 间距
    public var titleSpaceH : CGFloat = 4.0
    
    /// 是否为最后一行cell
    public var isLastCell : Bool = false
    
    /// line
    public lazy var lineView : UIView = {
    
        let line = UIView()
        line.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, 0.1)
        
        return line
    }()
    
    
    // MARK: -类方法
    class public func wwz_cell(tableView: UITableView, style: WWZTableViewCellStyle) -> WWZTableViewCell {
    
        let reuseID = "WWZ_REUSE_CELL_ID"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseID)
        
        if cell == nil {
            cell = self.init(style: style, reuseIdentifier: reuseID)
        }
        return cell as! WWZTableViewCell
    }
    
    public required init(style: WWZTableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.p_setupCell()

        self.p_addSubTitleLabel(style: style)
        self.p_addRightTitleLabel(style: style)
        self.p_addSwitchView(style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: -布局
    override open func layoutSubviews() {
        
        super.layoutSubviews()
        
        // imageView
        let imageX : CGFloat = 15.0
        let imageY : CGFloat = 7.0
        
        let imageWH : CGFloat = self.height - imageY*2
        
        var imageSize = CGSize(width: imageWH, height: imageWH)
        
        if self.imageView?.image != nil {
            
            if self.imageView!.image!.size.width > imageWH || self.imageView!.image!.size.height > imageWH {
                
                self.imageView?.contentMode = .scaleAspectFit
            }else{
            
                self.imageView?.contentMode = .center
                imageSize = self.imageView!.image!.size
            }
            
            self.imageView?.frame = CGRect(x: imageX, y: (self.height-imageSize.height)*0.5, width: imageSize.width, height: imageSize.height)
        }
        
        // textLabel
        guard let titleLabel = self.textLabel else {
            return
        }
        titleLabel.sizeToFit()
        
        titleLabel.x = self.imageView?.image == nil ? 15.0 : self.imageView!.right + 10
        
        titleLabel.y = (self.height-titleLabel.height)*0.5
        
        // text label 右边距
        let textLabelRightSpace : CGFloat = 10.0
        // text label 最大宽度
        var textLMaxWidth = self.contentView.width - titleLabel.x - textLabelRightSpace
        
        titleLabel.width = titleLabel.width < textLMaxWidth ? titleLabel.width : textLMaxWidth
        
        // right label
        if let rightTitleLabel = self.rightLabel, let _ = self.rightLabel!.text, self.rightLabel!.text!.characters.count > 0 {
            
            rightTitleLabel.sizeToFit()
            
            // 右边距
            let rightSpacing : CGFloat = self.accessoryType == .none ? 16.0 : 0
            
            // right label 最小宽度
            let rightLMinWidth : CGFloat = 60.0;
            
            // right label 最大宽度
            let rightLMaxWidth = self.contentView.width - titleLabel.right - textLabelRightSpace - rightSpacing
            
            if rightLMaxWidth < rightLMinWidth {
                
                rightTitleLabel.width = rightTitleLabel.width < rightLMinWidth ? rightTitleLabel.width : rightLMinWidth
            }else{
            
                rightTitleLabel.width = rightTitleLabel.width < rightLMaxWidth ? rightTitleLabel.width : rightLMaxWidth
            }
            
            rightTitleLabel.x = self.contentView.width - rightTitleLabel.width - rightSpacing
            rightTitleLabel.y = (self.height - rightTitleLabel.height) * 0.5
            
            textLMaxWidth = rightTitleLabel.x - titleLabel.x - textLabelRightSpace
        }
        
        titleLabel.width = titleLabel.width < textLMaxWidth ? titleLabel.width : textLMaxWidth
        
        // sub label
        if let subTitleLabel = self.subLabel, let _ = self.subLabel!.text, self.subLabel!.text!.characters.count > 0{
        
            subTitleLabel.sizeToFit()
            
            subTitleLabel.width = subTitleLabel.width < textLMaxWidth ? subTitleLabel.width : textLMaxWidth
            
            titleLabel.y = (self.height - titleLabel.height - subTitleLabel.height - self.titleSpaceH) * 0.5
            
            subTitleLabel.x = titleLabel.x
            subTitleLabel.y = titleLabel.bottom + self.titleSpaceH
        }
        
        self.selectedBackgroundView?.frame = self.bounds
        
        let leftX = self.isLastCell ? 0 : self.textLabel!.x
        
        let lineH : CGFloat = 0.5
        
        self.lineView.frame = CGRect(x: leftX, y: self.height - lineH, width: self.width-leftX, height: lineH)
    }
}


// MARK: -私有方法

extension WWZTableViewCell {

    // MARK: -设置cell
    fileprivate func p_setupCell() {
        
        self.backgroundColor = UIColor.white
        
        // text label
        self.textLabel?.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont.systemFont(ofSize: 17)
        self.textLabel?.textColor = UIColor.black
        
        // selected background color
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.colorFromRGBA(217, 217, 217, 1)
        
        // line
        self.contentView.addSubview(self.lineView)
    }
    // MARK: -添加sub label
    fileprivate func p_addSubTitleLabel(style: WWZTableViewCellStyle) {
        
        guard (style.rawValue & WWZTableViewCellStyle.subTitle.rawValue) > 0 else { return }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.colorFromRGBA(153, 153, 153, 1)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        self.addSubview(label)
        self.subLabel = label
    }
    // MARK: -添加right label
    fileprivate func p_addRightTitleLabel(style: WWZTableViewCellStyle) {
        
        guard (style.rawValue & WWZTableViewCellStyle.rightTitle.rawValue) > 0 else { return }
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.colorFromRGBA(153, 153, 153, 1)
        label.textAlignment = .right
        label.numberOfLines = 1
        
        self.addSubview(label)
        self.rightLabel = label
    }
    
    // MARK: -添加switch
    fileprivate func p_addSwitchView(style: WWZTableViewCellStyle) {
        
        guard (style.rawValue & WWZTableViewCellStyle.switchView.rawValue) > 0 else { return }
        
        let onSwitch = UISwitch()
        
        onSwitch.addTarget(self, action: #selector(WWZTableViewCell.p_changeSwitch), for: .valueChanged)
        
        self.accessoryView = onSwitch
        self.mySwitch = onSwitch
    }
    
    // MARK: -点击事件
    @objc fileprivate func p_changeSwitch(sender: UISwitch)  {
        
        self.tableViewCellDelegate?.tableViewCell(cell: self, didChangedSwitch: sender.isOn)
    }
}






