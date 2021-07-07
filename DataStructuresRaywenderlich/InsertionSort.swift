//
//  InsertionSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/11.
//

import Foundation

struct InsertionSort {

    public func insertionSort<Element>(_ array: inout [Element]) where Element: Comparable{


        guard array.count >= 2 else {
            return
        }

        for unsortArea in 1 ..< array.count {

            //这里是...全包含，因为要从这个unsortArea开始比
            for alreadysort in (1 ... unsortArea).reversed() {

                if array[alreadysort] < array[alreadysort - 1]{

                    array.swapAt(alreadysort, alreadysort-1)
                }else{
                    break
                }

            }

        }

    }

    //根据swift collection优化
    //Insertion sort traverses the collection backwards when shifting elements. As such, the collection must be of type BidirectionalCollection
    //bidirectional 英 [ˌbaɪdəˈrekʃənl] 双向的
    public func insertionSort<T>(_ collection: inout T)
        where T: BidirectionalCollection & MutableCollection,
              T.Element: Comparable {
      guard collection.count >= 2 else {
        return
      }
      for current in collection.indices {
        var shifting = current
        while shifting > collection.startIndex {
          let previous = collection.index(before: shifting)
          if collection[shifting] < collection[previous] {
            collection.swapAt(shifting, previous)
          } else {
            break
          }
          shifting = previous
        }
      }
    }

}
