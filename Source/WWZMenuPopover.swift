//
//  WWZMenuPopover.swift
//  wwz_swift
//
//  Created by wwz on 17/3/3.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public struct WWZMenuAttributes {
    
    var textColor : UIColor = UIColor.black
    var textFont : UIFont = UIFont.systemFont(ofSize: 14)
    var lineColor : UIColor = UIColor.colorFromRGBA(217, 217, 217, 1)
    var selectedBackgroundColor : UIColor = UIColor.colorFromRGBA(217, 217, 217, 1)
}

public protocol WWZMenuPopoverDelegate : NSObjectProtocol {
    
    func menuPopover(menuPopover: WWZMenuPopover, didSelectedItemAtIndex index: Int)
}

fileprivate class WWZMenuCell: WWZTableViewCell {
    
    // cell 相关属性
    var menuAttributes : WWZMenuAttributes = WWZMenuAttributes() {
    
        didSet {
        
            self.textLabel?.font = menuAttributes.textFont
            self.textLabel?.textColor = menuAttributes.textColor
            self.lineView.backgroundColor = menuAttributes.lineColor
            self.selectedBackgroundView?.backgroundColor = menuAttributes.selectedBackgroundColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.lineView.frame = CGRect(x: 15, y: self.height-0.5, width: self.width-15, height: 0.5)
    }
}

open class WWZMenuPopover: UIView {

    // MARK: -属性
    // 代理
    public var menuDelegate : WWZMenuPopoverDelegate?
    
    // 动画时间
    public var animateDuration : TimeInterval = 0.3
    
    // 圆角
    public var cornerRadius : CGFloat = 5.0 {
    
        didSet {
        
            self.tableView.layer.wwz_setCorner(radius: cornerRadius)
        }
    }
    
    public var menuAttributes : WWZMenuAttributes = WWZMenuAttributes()
    
    // 锚点相对于uiscreen的坐标
    public var anchorPoint : CGPoint = CGPoint(x: WWZ_SCREEN_WIDTH-39*0.5-(WWZ_SCREEN_WIDTH == 414.0 ? 10.0 : 5.0), y: 64.0) {
    
        didSet{
        
            self.y = anchorPoint.y
            self.x = anchorPoint.x - self.pointerFrame.size.width*0.5 - self.pointerFrame.origin.x
            self.finalCenter = self.center
        }
    }
    
    // 锚点相对于self的frame
    public var pointerFrame : CGRect = CGRect.zero {
    
        didSet {
        
            self.x = self.anchorPoint.x - pointerFrame.size.width*0.5 - pointerFrame.origin.x
            self.height = self.cellSize.height * CGFloat(self.titles.count) + pointerFrame.size.height
            
            self.tableView.frame = CGRect(x: 0, y: pointerFrame.maxY, width: self.width, height: self.height-pointerFrame.maxY)
            
            self.finalCenter = self.center
        }
    }
    // 锚点颜色
    public var anchorColor : UIColor = UIColor.white {
    
        didSet {
        
            self.tableView.backgroundColor = anchorColor
        }
    }
    
    // MARK: -私有属性
    fileprivate lazy var tableView: UITableView = {
    
        let tableV = UITableView(frame: CGRect(x: 0, y: self.pointerFrame.maxY, width: self.width, height: self.height-self.pointerFrame.maxY))
        tableV.dataSource = self
        tableV.delegate = self
        tableV.separatorStyle = .none
        tableV.isScrollEnabled = false
        tableV.backgroundColor = self.anchorColor
        tableV.layer.wwz_setCorner(radius: self.cornerRadius)
        return tableV
    }()
    
    // 标题
    fileprivate var titles: [String]!
    // 图标
    fileprivate var imageNames: [String]?
    // 单个cell尺寸
    fileprivate var cellSize : CGSize = CGSize.zero
    // 最后显示位置中心
    fileprivate var finalCenter: CGPoint = CGPoint.zero
    
    
    public convenience init(cellSize: CGSize, titles: [String], imageNames: [String]?) {
        
        self.init(frame: CGRect(origin: CGPoint.zero, size: cellSize))
        
        self.cellSize = cellSize
        
        self.titles = titles
        
        self.imageNames = imageNames
        
        // 初始设置
        self.p_setup()
    }
    
    override open func draw(_ rect: CGRect) {
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: self.pointerFrame.maxX, y: self.pointerFrame.maxY))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.origin.x, y: self.pointerFrame.maxY))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.midX, y: self.pointerFrame.origin.y))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.maxX, y: self.pointerFrame.maxY))
        
        self.anchorColor.set()
        bezierPath.fill()
    }
}

// MARK: -代理
extension WWZMenuPopover : UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = WWZMenuCell.wwz_cell(tableView: tableView, style: .none) as! WWZMenuCell
        
        cell.menuAttributes = self.menuAttributes
        
        cell.textLabel?.text = self.titles[indexPath.row]
        
        if let imageNames = self.imageNames {
        
            cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = self.menuDelegate {
            
            delegate.menuPopover(menuPopover: self, didSelectedItemAtIndex: indexPath.row)
        }
        self.wwz_dismiss()
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.cellSize.height
    }
}

public extension WWZMenuPopover {

    fileprivate func p_setup() {
        
        self.backgroundColor = UIColor.clear
        
        let pointerSize = CGSize(width: 18.0, height: 10.0)
        
        self.pointerFrame = CGRect(origin: CGPoint(x: self.width-pointerSize.width-self.cornerRadius*2, y: 0), size: pointerSize)
        
        // 完善self尺寸
        self.x = self.anchorPoint.x - self.pointerFrame.size.width*0.5 - self.pointerFrame.origin.x
        self.y = self.anchorPoint.y
        self.height = self.cellSize.height * CGFloat(self.titles.count) + self.pointerFrame.size.height
        self.finalCenter = self.center
        
        // 添加tableView
        self.addSubview(self.tableView)
    }
    
    public func wwz_show() {
        
        let button = UIButton(frame: UIScreen.main.bounds)
        button.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, 0.1)
        button.addTarget(self, action: #selector(WWZMenuPopover.wwz_dismiss), for: .touchUpInside)
        button.addSubview(self)
        
        UIApplication.shared.keyWindow?.addSubview(button)
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.center = self.anchorPoint
        
        button.alpha = 0
        
        UIView.animate(withDuration: self.animateDuration) {
            
            self.transform = CGAffineTransform.identity
            
            self.center = self.finalCenter
            
            button.alpha = 1.0
        }
    }
    
    public func wwz_dismiss() {
        
        UIView.animate(withDuration: self.animateDuration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.center = self.anchorPoint
            self.superview?.alpha = 0.0
            
            }) { (_) in
                
                self.superview?.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
}
