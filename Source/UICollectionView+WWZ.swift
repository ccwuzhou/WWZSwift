//
//  UICollectionView-WWZ.swift
//  wwz_swift
//
//  Created by wwz on 17/3/2.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit

public extension UICollectionViewFlowLayout {

    /// 固定item count
    public convenience init(viewSize: CGSize, sectionInset: UIEdgeInsets, itemCount: Int, lineSpace: CGFloat, itemSpace: CGFloat, scrollDirection: UICollectionViewScrollDirection) {
        
        self.init()
        
        //滚动方向
        self.scrollDirection = scrollDirection
        
        self.minimumLineSpacing = lineSpace
        self.minimumInteritemSpacing = itemSpace
        
        var itemWH : CGFloat = 0;
        
        if (scrollDirection == .vertical) {
            
            itemWH = (viewSize.width - sectionInset.left - sectionInset.right - CGFloat(itemCount - 1) * itemSpace) / CGFloat(itemCount) - 2
        }else{
            
            itemWH = (viewSize.height - sectionInset.top - sectionInset.bottom - CGFloat(itemCount-1) * lineSpace) / CGFloat(itemCount) - 2
        }
        
        self.itemSize = CGSize(width: itemWH, height: itemWH)
        
        self.sectionInset = sectionInset
    }
    
    ///固定itemSize
    public convenience init(sectionInset: UIEdgeInsets, itemSize: CGSize, lineSpace: CGFloat, itemSpace: CGFloat, scrollDirection: UICollectionViewScrollDirection) {
        
        self.init()
        
        //滚动方向
        self.scrollDirection = scrollDirection
        
        self.minimumLineSpacing = lineSpace
        self.minimumInteritemSpacing = itemSpace
        
        self.itemSize = itemSize
        
        self.sectionInset = sectionInset
    }
}

extension UICollectionView {
    
}
