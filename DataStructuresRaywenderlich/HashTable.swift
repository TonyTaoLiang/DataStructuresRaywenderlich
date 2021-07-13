//
//  HashTable.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/7/9.
//

import Foundation
//1.假设我们有 10 万条 URL 访问日志，如何按照访问次数给 URL 排序？
//思路：字典存储访问的次数[key=url, value = 次数]
//遍历数组，依次取出里面的次数放入桶中（如果数量巨大可以用快排）

//2.有两个字符串数组，每个数组大约有 10 万条字符串，如何快速找出两个数组中相同的字符串
//思路：类似twosum的思想一个数组存字典[key=url, value = 0/1],然后拿另一个数组入字典查找如果不为0则重复

struct HashTable<T: Hashable> {

    //1.问题一桶排序的解法
    public func hashSort(array: [T]) -> [T]{

        var dict: [T : Int] = [:]

        //将次数存入字典
        for url in array {

            guard let count = dict[url] else {
                dict[url] = 1
                continue
            }

            dict[url] = count + 1
        }

        //找出最大桶数
        var bucketMax = 0
        for value in dict.values {
            bucketMax = value > bucketMax ? value : bucketMax
        }

        //放入桶
        var buckets: [[T]] = Array.init(repeating: [], count: bucketMax)

        for url in array {

            let count = dict[url]!

            buckets[count-1].append(url)
        }

        //平铺展开二维数组
        return buckets.flatMap {$0}

    }

    
}
