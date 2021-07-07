//
//  QuickSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/17.
//

import Foundation
//1.最复杂的空间、时间复杂度
//2.lmomoto 最后pivot
//3.morn 最前pivot
//4.选最前或最后，如果数组本身有序（正序或倒序）会退化成O(n^2).因为层级不再是logn(联想不平衡的树)。
//  会出现这种情况 less: [ ] equal: [1] greater: [8, 7, 6, 5, 4, 3, 2]
//  所以两两比较，选择前，中，后三者中的中位（median of three pivot）
//5。2和3处理数组中有相同元素不太行，方式2：相同元素在左边且都不在一组。方式3:相同元素可能交换的到处都是。不稳定
//所以选择Dutch national flag partitioning（🇳🇱国旗）This technique is named after the Dutch flag which has three bands of colors: red, white and blue. This is similar to how you create three partitions.
/* 方式5:
 [0, 3, -1, 2, 5, 1, 8, 8, 27, 18, 21, 9, 12]
                     s
                           e
                        l
 方法会返回smaller，larger的index。这时候分成了三组[0, 3, -1, 2, 5, 1] [8,8] [27, 18, 21, 9, 12] 这时候相同的元素也在一组了
 */

//1.最复杂的空间、时间复杂度
public func quickSortNaive<T: Comparable>(_ a: [T]) -> [T]{


    guard a.count > 1 else {
        return a
    }

    let middle = a.count/2
    let pivot = a[middle]
    let less = a.filter { ($0 < pivot) }
    let equal = a.filter { ($0 == pivot) }
    let larger = a.filter { ($0 > pivot) }

    return quickSortNaive(less) + equal + quickSortNaive(larger)

}

//2.Lomuto 选取最后一个元素作为pivot
public func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int{

    let pivot = a[high]
    
    var i = low
    //i j同时往右跑
    for j in low ..< high {

        if a[j] <= pivot {

            a.swapAt(i, j)
            i += 1
        }

    }

    a.swapAt(i, high)

    return i
}

public func quicksortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {

    //数组最后只有一个元素了退出递归
    if low < high {

        let pivot = partitionLomuto(&a, low: low, high: high)

        //小于边
        quicksortLomuto(&a, low: low , high: pivot - 1)

        //大于边
        quicksortLomuto(&a, low: pivot + 1 , high: high)
    }

}

//3.Hoare’s partitioning 选取最前一个元素作为pivot
public func partitionHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {

    let pivot = a[low]
    var i = low - 1
    var j = high + 1

    while true {
        //i j 2头往中间跑
        repeat{ j -= 1 } while a[j] > pivot
        //每次循环一次，这里就+1 如果 < pivot 就一直++++
        repeat{ i += 1 } while a[i] < pivot

        //能到这里说明当前a[i] >= pivot a[j] <= pivot
        //下面一交换就将小的到左边，大的到右边
        if i < j {
            a.swapAt(i, j)
        } else {
            return j
        }

    }

}

public func quicksortHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) {

    if low < high {

        let pivot = partitionHoare(&a, low: low, high: high)

        quicksortHoare(&a, low: low, high: pivot)

        quicksortHoare(&a, low: pivot+1, high: high)
    }

}

//4.优化：median of three pivot 取中位数来作为pivot 避免退化O(n^2)
public func  medianOfThree<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int{

    let middle = (low + high)/2

    //两两比较
    if a[low] > a[middle] {
        a.swapAt(low, middle)
    }
    if a[low] > a[high]{
        a.swapAt(low, high)
    }
    if a[middle] > a[high]{
        a.swapAt(middle, high)
    }

    return middle

}

//采用medianOfThree对Lomuto的优化
public func quickSortMedian<T: Comparable>(_ a: inout [T], low: Int, high: Int) {

    if low < high {

        //这样只是第一次不是选择最后一个为pivot，下面的递归还是选的最后一个
        //个人觉得最好的优化还是将medianOfThree放到partitionLomuto里面去？
        let middle = medianOfThree(&a, low: low, high: high)
        a.swapAt(middle, high)

        let pivot = partitionLomuto(&a, low: low, high: high)
        quicksortLomuto(&a, low: low, high: pivot - 1)
        quicksortLomuto(&a, low: pivot + 1, high: high)


    }

}

//5.Dutch national flag partitioning(🇳🇱)
//pivotIndex:最优是使用medianOfThree获取到的index 或者直接取第一个或最后一个
public func partitionDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int){

    let pivot = a[pivotIndex]

    var smaller = low
    var equal = low
    var larger = high

    while equal <= larger {

        if a[equal] > pivot {
            a.swapAt(equal, larger)
            larger -= 1
        } else if a[equal] == pivot {
            equal += 1
        } else{

            //low的值只会是<=pivot(可自己step by step尝试)
            a.swapAt(smaller, equal)
            equal += 1
            smaller += 1

        }
    }

    return (smaller,larger)
}

public func quicksortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {

    if low < high {

        /*
         [0, 3, -1, 2, 5, 8, 8, 1, 27, 18, 21, 9, 12]
                          s
                                e
                                l

         [0, 3, -1, 2, 5, 1, 8, 8, 27, 18, 21, 9, 12]
                             s
                                   e
                                l
         */
        //这里直接传的high，最优是medianOfThree获取到的index
        let (middleFirst, middleLast) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: high)
        quicksortDutchFlag(&a, low: low, high: middleFirst - 1)
        quicksortDutchFlag(&a, low: middleLast + 1, high: high)

    }

}
