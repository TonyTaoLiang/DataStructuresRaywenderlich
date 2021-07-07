//
//  MergeSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/14.
//

import Foundation

struct MergeSort {


    public func mergeSort<Element>(_ array: [Element]) -> [Element] where Element: Comparable{

        guard array.count > 1 else {
            return array
        }

        let middle = array.count / 2

        let left = mergeSort(Array(array[..<middle]))
        let right = mergeSort(Array(array[middle...]))

        return merge(left, right)
    }


    public func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable{

        var leftIndex = 0
        var rightIndex = 0

        var result: [Element] = []

        //左右里面都有值
        while leftIndex < left.count && rightIndex < right.count {

            if left[leftIndex] < right[rightIndex] {

                //左边小先放入result，index++
                result.append(left[leftIndex])
                leftIndex += 1

            } else if(left[leftIndex] > right[rightIndex]){

                result.append(right[rightIndex])
                rightIndex += 1
            } else {

                //相等，为了保持稳定性（即相同的元素不调换位置）先让左入，然后右入
                result.append(left[leftIndex])
                leftIndex += 1
                result.append(right[rightIndex])
                rightIndex += 1
            }

        }

        //左右 有一个已经空了

        if leftIndex == left.count {
            result.append(contentsOf: right[rightIndex...])
        }

        if rightIndex == right.count {
            result.append(contentsOf: left[leftIndex...])
        }

        return result
    }


    
    


}
