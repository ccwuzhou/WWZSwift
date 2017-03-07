//
//  WWZMenuPopover.swift
//  wwz_swift
//
//  Created by wwz on 17/3/3.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

private let MENU_ANIMATION_DURATION : TimeInterval = 0.3

private let MENU_CORNER_RADIUS : CGFloat = 5.0

protocol WWZMenuPopoverDelegate : NSObjectProtocol {
    
    func menuPopover(menuPopover: WWZMenuPopover, didSelectedItemAtIndex index: Int)
}

class WWZMenuCell: WWZTableViewCell {
    
    override init(style: WWZTableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        self.textLabel?.textColor = UIColor.black
        self.lineView.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, 0.2)
        self.selectedBackgroundView?.backgroundColor = UIColor.colorFromRGBA(217, 217, 217, 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.lineView.frame = CGRect(x: 15, y: self.height-0.5, width: self.width-15, height: 0.5)
    }
}

class WWZMenuPopover: UIView {

    // MARK: -属性
    var menuDelegate : WWZMenuPopoverDelegate?
    
    // 锚点相对于uiscreen的坐标
    var anchorPoint : CGPoint = CGPoint.zero {
    
        didSet{
        
            self.y = anchorPoint.y
            self.x = anchorPoint.x - self.pointerFrame.size.width*0.5 - self.pointerFrame.origin.x
            self.finalCenter = self.center
        }
    }
    
    // 锚点相对于self的frame
    var pointerFrame : CGRect = CGRect.zero {
    
        didSet {
        
            self.x = self.anchorPoint.x - pointerFrame.size.width*0.5 - pointerFrame.origin.x
            self.height = self.cellSize.height * CGFloat(self.titles.count) + pointerFrame.size.height
            
            self.tableView.frame = CGRect(x: 0, y: pointerFrame.maxY, width: self.width, height: self.height-pointerFrame.maxY)
            
            self.finalCenter = self.center
        }
    }
    // 锚点颜色
    var anchorColor : UIColor = UIColor.white {
    
        didSet {
        
            self.tableView.backgroundColor = anchorColor
        }
    }
    
    // MARK: -私有属性
    private lazy var tableView: UITableView = {
    
        let tableV = UITableView(frame: CGRect(x: 0, y: self.pointerFrame.maxY, width: self.width, height: self.height-self.pointerFrame.maxY))
        tableV.dataSource = self
        tableV.delegate = self
        tableV.separatorStyle = .none
        tableV.isScrollEnabled = false
        tableV.backgroundColor = self.anchorColor
        tableV.layer.wwz_setCorner(radius: 5.0)
        return tableV
    }()
    
    // 标题
    fileprivate var titles: [String]!
    // 图标
    fileprivate var imageNames: [String]?
    // 单个cell尺寸
    fileprivate var cellSize : CGSize = CGSize.zero
    
    fileprivate var finalCenter: CGPoint = CGPoint.zero
    
    
    convenience init(cellSize: CGSize, titles: [String], imageNames: [String]?) {
        
        self.init(frame: CGRect(origin: CGPoint.zero, size: cellSize))
        
        self.cellSize = cellSize
        
        self.titles = titles
        
        self.imageNames = imageNames
        
        // 初始设置
        self.p_setup()
        
        // 添加tableView
        self.addSubview(self.tableView)
    }
}

// MARK: -代理
extension WWZMenuPopover : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = WWZTableViewCell.wwz_cell(tableView: tableView, style: .none)
        
        cell.textLabel?.text = self.titles[indexPath.row]
        
        if let imageNames = self.imageNames {
        
            cell.imageView?.image = UIImage(named: imageNames[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let delegate = self.menuDelegate {
            
            delegate.menuPopover(menuPopover: self, didSelectedItemAtIndex: indexPath.row)
        }
        self.wwz_dismiss()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.cellSize.height
    }
}

extension WWZMenuPopover {

    fileprivate func p_setup() {
        
        self.backgroundColor = UIColor.clear
        
        let pointerSize = CGSize(width: 18.0, height: 10.0)
        
        self.anchorPoint = CGPoint(x: SCREEN_WIDTH-39*0.5-(SCREEN_WIDTH == 414.0 ? 10.0 : 5.0), y: 64.0)
        
        self.pointerFrame = CGRect(origin: CGPoint(x: self.width-pointerSize.width-MENU_CORNER_RADIUS*2, y: 0), size: pointerSize)
        
        // 完善self尺寸
        self.x = self.anchorPoint.x - self.pointerFrame.size.width*0.5 - self.pointerFrame.origin.x
        self.y = self.anchorPoint.y
        self.height = self.cellSize.height * CGFloat(self.titles.count) + self.pointerFrame.size.height
        self.finalCenter = self.center
    }
    
    func wwz_show() {
        
        let button = UIButton(frame: UIScreen.main.bounds)
        button.backgroundColor = UIColor.colorFromRGBA(0, 0, 0, 0.1)
        button.addTarget(self, action: #selector(WWZMenuPopover.wwz_dismiss), for: .touchUpInside)
        button.addSubview(self)
        
        UIApplication.shared.keyWindow?.addSubview(button)
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.center = self.anchorPoint
        
        button.alpha = 0
        
        UIView.animate(withDuration: MENU_ANIMATION_DURATION) { 
            
            self.transform = CGAffineTransform.identity
            
            self.center = self.finalCenter
            
            button.alpha = 1.0
        }
    }
    
    func wwz_dismiss() {
        
        UIView.animate(withDuration: MENU_ANIMATION_DURATION, animations: { 
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.center = self.anchorPoint
            self.superview?.alpha = 0.0
            
            }) { (_) in
                
                self.superview?.removeFromSuperview()
                self.removeFromSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: self.pointerFrame.maxX, y: self.pointerFrame.maxY))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.origin.x, y: self.pointerFrame.maxY))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.midX, y: self.pointerFrame.origin.y))
        bezierPath.addLine(to: CGPoint(x: self.pointerFrame.maxX, y: self.pointerFrame.maxY))
        
        self.anchorColor.set()
        bezierPath.fill()
    }
}
