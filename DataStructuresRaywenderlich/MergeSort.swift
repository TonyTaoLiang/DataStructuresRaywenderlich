//
//  MergeSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/14.
//

import Foundation

struct MergeSort {

    /*
     可以看到sort的入栈顺序，当执行一次merge时，一定是有2个sort返回并有序了，如下图，sort[0,0]和sort[1,1]（递归返回的条件是start<end）都返回了，然后执行到merge，执行完merge后，sort[0,1]出栈，此时的栈顶为sort[0,2]函数，可以看出它的前半部分已经计算完，只需要计算后半部分，即第二个sort，然后再次merge，再sort[0,2]出栈。。。
     参考图片Merge1，Merge2.
     Merge2和Merge3合起来看，了解递归的每一步
     归并排序算法的过程图解：https://cloud.tencent.com/developer/article/1080999
     */

    public func mergeSort<Element>(_ array: [Element]) -> [Element] where Element: Comparable{

        guard array.count > 1 else {
            return array
        }

        let middle = array.count / 2
        print("归并左====")
        let left = mergeSort(Array(array[..<middle]))
        print("归并右====")
        let right = mergeSort(Array(array[middle...]))
/**
         归并左====
         归并左====
         归并右====
         归并右====
         归并左====
         归并右====
         归并左====
         归并右====
         */
        return merge(left, right)
    }


    public func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable{
        print("Merge-left:",left)
        print("Merge-right:",right)
//        7 2 6 3 9
//        Merge-left: [7]
//        Merge-right: [2]
//        Merge-left: [3]
//        Merge-right: [9]
//        Merge-left: [6]
//        Merge-right: [3, 9]
//        Merge-left: [2, 7]
//        Merge-right: [3, 6, 9]
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
