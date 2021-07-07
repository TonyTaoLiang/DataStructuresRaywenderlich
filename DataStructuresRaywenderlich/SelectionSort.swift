//
//  SelectionSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/9.
//

import Foundation

struct SelectionSort {

    public func selectionSort<Element>(_ array: inout [Element])
        where Element: Comparable {

      guard array.count >= 2 else {
        return
      }

        for current in 0..<array.count-1 {


            var lowest = current

            for other in (current + 1)..<array.count  {

                if array[other] < array[lowest] {
                    lowest = other
                }

            }

            if lowest != current {
                array.swapAt(lowest, current)
            }

        }

    }
    //根据swift collection优化
    public func selectionSortUpdate<T>(_ collection: inout T)
        where T: MutableCollection, T.Element: Comparable {
      guard collection.count >= 2 else {
        return
      }
      for current in collection.indices {
        var lowest = current
        var other = collection.index(after: current)
        while other < collection.endIndex {
          if collection[lowest] > collection[other] {
            lowest = other
          }
          other = collection.index(after: other)
        }
        if lowest != current {
          collection.swapAt(lowest, current)
        }
      }
    }

}
