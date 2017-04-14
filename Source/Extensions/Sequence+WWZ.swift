//
//  Sequence+WWZ.swift
//  WWZSwift
//
//  Created by apple on 2017/4/13.
//  Copyright © 2017年 tijio. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {

    func isSubset<S: Sequence>(of other: S) -> Bool where S.Iterator.Element == Iterator.Element {
        
        let otherSet = Set(other)
        
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence where Iterator.Element: Equatable {
    
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Iterator.Element == Iterator.Element
    {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence {

    func isSubset<S: Sequence>(of other: S, by areEquivalent:(Iterator.Element, S.Iterator.Element) -> Bool) -> Bool {
        
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0)}) else {
                return false
            }
        }
        return true
    }
}

extension RandomAccessCollection {
    
    public func binarySearch(for value: Iterator.Element, areInIncreasingOrder:(Iterator.Element, Iterator.Element) -> Bool) -> Index? {
        
        guard !isEmpty else {
            return nil
        }
        var left = startIndex
        var right = index(before: endIndex)
        
        while left <= right {
            
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            
            if areInIncreasingOrder(candidate, value) {
                left = index(after: mid)
            }else if areInIncreasingOrder(value, candidate) {
                
                right = index(before: mid)
            }else{
                
                return mid
            }
        }
        return nil
    }
}



extension RandomAccessCollection
    where Iterator.Element: Comparable
{
    func binarySearch(for value: Iterator.Element) -> Index? {
        return binarySearch(for: value, areInIncreasingOrder: <)
    }
}
extension SignedInteger {
    
    static func arc4random_uniform(_ upper_bound: Self) -> Self {
        
        precondition(upper_bound>0 && upper_bound.toIntMax() < UInt32.max.toIntMax(), "arc4random_uniform only callable up to \(UInt32.max)")
        
        return numericCast(Darwin.arc4random_uniform(numericCast(upper_bound)))
    }
}

extension MutableCollection where Self: RandomAccessCollection {
    
    mutating func shuffle() {
        
        var i = startIndex
        let beforeEndIndex = index(before: endIndex)
        
        while i < beforeEndIndex {
            let dist = distance(from: i, to: endIndex)
            let randomDistance = IndexDistance.arc4random_uniform(dist)
            
            let j = index(i, offsetBy: randomDistance)
            guard i != j else {
                continue
            }
            
            swap(&self[i], &self[j])
            formIndex(after: &i)
        }
    }
}
