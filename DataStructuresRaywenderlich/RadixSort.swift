//
//  RadixSort.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/21.
//

import Foundation

//1.计数排序可以看成是特殊的桶排序。一个桶的范围是1，不是类似0～100这种。他的排序方法很巧妙，看王铮
//2.基数排序：每一位可以看成是一次桶排序或者计数排序（例如1024:个十百千 一共4位，4次桶排序）


extension Array where Element == Int {
    //MARK:基数排序
    public mutating func radixSort() {

        //因为是int 类似个十百千 所以基数是10
        let base = 10

        //每一位
        var digits = 1

        var done = false

        //基数排序的每一次循环里面采用的是桶排序
        while !done {

            done = true

            //创建10个桶 每个桶里可以放多个球 二维数组
            var buckets: [[Int]] = .init(repeating: [], count: 10)

            //遍历原始数组
            forEach { (number) in

                //依次取出个十百千
                let remainingPart = number / digits
                //取出当前这一位上的值
                let digit = remainingPart % base
                //将原始数组中的元素 放入对应的桶 （例如1024第一次个位是4，将1024放入4号桶）
                buckets[digit].append(number)

                //如果数组中所有的元素循环完，只要有一个当前位比如千位还有值 就可以继续。如果全部都<0则 说明结束了。而done在循环最开始已经为true了
                if remainingPart > 0 {
                    done = false
                }
            }

            //每一位排完序 拆开二维数组 即给数组排了一次序
            self = buckets.flatMap{$0}
            digits *= base
        }
    }

    //MARK:计数排序
    public mutating func countingSort(){

        //1.算出数组中最大的数（8个学生 0～5分）即创建多少个桶（这里6个桶0～5）
        var bucketCount = 0

        forEach { score in

            if score > bucketCount {

                bucketCount = score

            }

        }
        //这里不是二维数组，上面的需要将实际的值放进去。这里只需要计算每个桶里的个数
        var buckets: [Int] = .init(repeating: 0, count: bucketCount + 1)

        //2.放入每个桶里，计算每个桶里的个数（计数）
        forEach { score in

            buckets[score] += 1

        }

        //3.每一个桶的个数是前一个桶和自己的累加。以此算出改元素的下标位置
        for i in 1 ..< buckets.count {

            buckets[i] = buckets[i] + buckets[i-1]

        }


        //4.逆序遍历原数组，从桶中依次取出球放入临时数组，然后每个桶的累加的个数减去1（下标减1）
        var tempArray: [Int] = .init(repeating: 0, count: self.count)

        for score in self.reversed() {

            let index = buckets[score] - 1
            tempArray[index] = score 
            buckets[score] -= 1

        }

        //5.还给原数组

        self.replaceSubrange(0..<self.count, with: tempArray)

    }

    //MARK:两数之和 自己想的用桶排序（target个桶 把对应的index放入桶 首尾相加必为target 看其中有没有球）
    //这个有点问题，bucket的index不能是负数 如果数组中有复数就崩了
    func twoSum1(_ nums: [Int], _ target: Int) -> [Int] {

        var bucket: [[Int]] = .init(repeating: [], count: target + 1)

        for i in 0..<nums.count {

            if nums[i] <= target {
                bucket[nums[i]].append(i)
            }

        }

        for i in 0...target {

            if bucket[i].count > 0 && bucket[target-i].count > 0{

                if i == target - i {
                    return bucket[i].count > 1 ? [bucket[i][0], bucket[target-i][1]] : []
                }else{
                    return [bucket[i][0], bucket[target-i][0]]
                }

            }

        }

        return []
    }

    //MARK:两数之和：字典的方式
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {

        var dict: [Int : Int] = [:]
      
        for i in 0..<nums.count {

//            if dict.keys .contains(nums[i]) {
//
//                return [dict[nums[i]]!,i]
//
//            }

//            dict.updateValue(i, forKey: target - nums[i])
            if let index = dict[nums[i]] {
                return [index,i]
            }
            dict[target - nums[i]] = i
            
        }

        return []
    }

}
