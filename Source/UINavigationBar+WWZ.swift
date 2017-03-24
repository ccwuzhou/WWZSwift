//
//  UINavigationBar+WWZ.swift
//  WWZSwift
//
//  Created by wwz on 17/3/8.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

private var WWZ_NAVBAR_OVERLAY_KEY = "WWZ_NAVBAR_OVERLAY_KEY"

public extension UINavigationBar {

    /// 背景视图
    private var wwz_overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &WWZ_NAVBAR_OVERLAY_KEY) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &WWZ_NAVBAR_OVERLAY_KEY, newValue as UIView?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    /// 设置标题
    public func wwz_setTitle(color: UIColor, font: UIFont) {
        
        self.titleTextAttributes = [NSForegroundColorAttributeName:color,NSFontAttributeName:font]
    }
    /// 设置背景颜色
    public func wwz_setBackgroundColor(backgroundColor: UIColor) {
        
        if self.wwz_overlay == nil {
            
            self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            
            self.wwz_overlay  = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height+20))
            self.wwz_overlay?.isUserInteractionEnabled = false
            self.wwz_overlay?.autoresizingMask = .flexibleWidth
        }
        self.wwz_overlay?.backgroundColor = backgroundColor
        subviews.first?.insertSubview(self.wwz_overlay!, at: 0)
    }
    
    /// 是否隐藏下面线
    public func wwz_setShadowImage(isHidden: Bool) {
        
        let lineImageView = self.wwz_findNavLineImageViewOn(view: self)
        
        lineImageView?.isHidden = isHidden
    }
    
    /// 还原，viewWillDisAppear调用
    public func wwz_reset() {
        
        self.wwz_setShadowImage(isHidden: false)
        
        self.setBackgroundImage(nil, for: .default)
        
        self.wwz_overlay?.removeFromSuperview()
        self.wwz_overlay = nil
    }
    
    /// 设置tabbar内所有视图的alpha
    public func wwz_setElementsAlpha(alpha: CGFloat) {
        
        for element in self.subviews {
            
            if element.isKind(of: NSClassFromString("UINavigationItemView") as! UIView.Type) ||
                element.isKind(of: NSClassFromString("UINavigationButton") as! UIButton.Type) ||
                element.isKind(of: NSClassFromString("UINavBarPrompt") as! UIView.Type){
                
                element.alpha = alpha
            }
            // ios9:_UINavigationBarBackground
            // ios10:_UIBarBackground
            if element.isKind(of: NSClassFromString("_UINavigationBarBackIndicatorView") as! UIView.Type) || element.isKind(of: NSClassFromString("_UIBarBackground") as! UIView.Type) || element.isKind(of: NSClassFromString("_UINavigationBarBackground") as! UIView.Type) {
                
                element.alpha = element.alpha == 0 ? 0 : alpha
            }
        }
        
        self.items?.forEach({ (item) in
            
            if let titleView = item.titleView {
                titleView.alpha = alpha
            }
            for BBItems in [item.leftBarButtonItems, item.rightBarButtonItems] {
                BBItems?.forEach({ (barButtonItem) in
                    if let customView = barButtonItem.customView {
                        customView.alpha = alpha
                    }
                })
            }
        })
    }
}

public extension UINavigationBar {

    // MARK: - 其他内部方法
    /// 寻找导航栏下的横线  （递归查询导航栏下边那条分割线）
    fileprivate func wwz_findNavLineImageViewOn(view: UIView) -> UIImageView? {
        
        if (view.isKind(of: UIImageView.classForCoder())  && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        for subView in view.subviews {
            
            let imageView = self.wwz_findNavLineImageViewOn(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
}

extension UINavigationBar {

    /**
     在func scrollViewDidScroll(_ scrollView: UIScrollView)调用
     @param color 最终显示颜色
     @param scrollView 当前滑动视图
     @param value 滑动临界值，依据需求设置
     */
    fileprivate func change(_ color: UIColor, with scrollView: UIScrollView, andValue value: CGFloat) {
        if scrollView.contentOffset.y < -value{
            // 下拉时导航栏隐藏，无所谓，可以忽略
            self.isHidden = true
        } else {
            self.isHidden = false
            // 计算透明度
            let alpha: CGFloat = scrollView.contentOffset.y / value > 1.0 ? 1 : scrollView.contentOffset.y / value
            //设置一个颜色并转化为图片
            let image: UIImage? = imageFromColor(color: color.withAlphaComponent(alpha))
            self.setBackgroundImage(image, for: .default)
        }
    }
    // 通过"UIColor"返回一张“UIImage”
    fileprivate func imageFromColor(color: UIColor) -> UIImage {
        //创建1像素区域并开始图片绘图
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        //创建画板并填充颜色和区域
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        //从画板上获取图片并关闭图片绘图
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
