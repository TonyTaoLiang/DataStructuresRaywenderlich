//
//  BinarySearch.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/5/24.
//

import Foundation
extension RandomAccessCollection where Element: Comparable{

    //range默认值nil
    func binarySearch(for value: Element, in range: Range<Index>? = nil) -> Index? {

        //如果不传range就是整个数组
        let range = range ?? startIndex..<endIndex
        //数组是否为空
        guard range.lowerBound < range.upperBound else {
            return nil
        }

        let size = distance(from: range.lowerBound, to: range.upperBound)

        let middle = index(range.lowerBound, offsetBy: size/2)

        if self[middle] == value {
            return middle
        } else if(self[middle] < value) {
//            return binarySearch(for: value, in: middle..<range.upperBound) //这是我自己的写法也可以，感觉不用调用index方法
            return binarySearch(for: value, in: index(after: middle)..<range.upperBound)
        } else {
            return binarySearch(for: value, in: range.lowerBound ..< middle)
        }
    }

}
