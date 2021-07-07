//
//  BubbleSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/8.
//

import Foundation

struct BubbleSort {

    public func bubbleSort<Element>(_ array: inout [Element])
    where Element: Comparable{

        guard array.count >= 2 else {
            return
        }

        for end in (1..<array.count).reversed() {

            //交换的标志位 如果有一次没有交换 则表示已经排序完毕可以提前退出循环
            var swapped: Bool = false

            for current in 0..<end {

                if array[current] > array[current+1] {
                    array.swapAt(current, current+1)
                    swapped = true
                }

            }

            if !swapped {
                return
            }

        }

    }


    //根据swift collection优化
    public func bubbleSortUpdate<T>(_ collection: inout T)
        where T: MutableCollection, T.Element: Comparable {
      guard collection.count >= 2 else {
          return
      }
      for end in collection.indices.reversed() {
        var swapped = false
        var current = collection.startIndex
        while current < end {
          let next = collection.index(after: current)
          if collection[current] > collection[next] {
            collection.swapAt(current, next)
            swapped = true
          }
          current = next
        }
        if !swapped {
          return
        }
      }
    }
}

