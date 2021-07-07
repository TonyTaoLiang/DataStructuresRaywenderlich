//
//  Heap.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/2.
//

import Foundation

//MARK: - 注意这里的堆跟我们之前的讨论的内存堆是2码事
struct Heap<Element: Equatable> {

    var sort: (Element,Element) -> Bool
    var elements: [Element] = []

    init( sort: @escaping (Element,Element) -> Bool, elements: [Element] = []) {
        self.sort = sort
        self.elements = elements

        //开始堆化
        if !self.elements.isEmpty {

            //类似于王铮的第二种堆排序方式 从后往前遍历数组元素 然后从上往下堆化。这样就可以从最后一个拥有子节点的开始堆化

            for i in stride(from: elements.count/2 - 1, through: 0, by: -1) {

                siftDown(from: i)
            }
        }
    }

    var isEmpty: Bool{

        return elements.isEmpty
    }

    var count: Int {
      return elements.count
    }

    func peek() -> Element? {
      return elements.first
    }

    func leftChildIndex(ofParentAt index: Int) -> Int {
      return (2 * index) + 1
    }

    func rightChildIndex(ofParentAt index: Int) -> Int {
      return (2 * index) + 2
    }

    func parentIndex(ofChildAt index: Int) -> Int {
      return (index - 1) / 2
    }

//删除堆顶元素
    mutating func remove() -> Element? {

        guard !isEmpty else {
            return nil
        }
        //交换末尾和堆顶元素
        elements.swapAt(0, count-1)

        defer {

            siftDown(from: 0)
        }

        return elements.removeLast()

    }

    //从上往下(优化一下这个方法，为了王铮的堆排序。left < count 这个换成默认参数，不一定是整个数组长度)
    mutating func siftDown(from index: Int, to count: Int = 0){

        //不传count默认是整个数组
        let realCount = count == 0 ? self.count : count

        var parent = index

        while true {

            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)

            var candidate = parent

            //先判断左
            if left < realCount && sort(elements[left],elements[candidate]){
                candidate = left
            }
            if right < realCount && sort(elements[right],elements[candidate]){
                candidate = right
            }
            //到底了
            if parent == candidate {
                return
            }
            //交换父子
            elements.swapAt(candidate, parent)
            //继续往下走，当前关注节点变为之前的子节点
            parent = candidate

        }

    }


    mutating func insert(_ element: Element) {

        elements.append(element)

        siftUp(from: elements.count-1)

    }


    mutating func siftUp(from index: Int){

        var parent = parentIndex(ofChildAt: index)
        var candidate = index

        while candidate > 0 && sort(elements[candidate],elements[parent]) {

            elements.swapAt(candidate, parent)

            candidate = parent

            parent = parentIndex(ofChildAt: candidate)
        }
    }

    //移除指定位置的节点
    mutating func remove(at index: Int) -> Element? {

        guard index < elements.count else {
            return nil // 1
        }

        if index == elements.count - 1 {
            return elements.removeLast()
        } else {

            //与最后一个元素交换
            elements.swapAt(index, elements.count-1)

            defer {
                //交换的元素可大可小 所以可能是往下堆化 也可能是往上堆化
                siftUp(from: index)
                siftDown(from: index)
            }

            return elements.removeLast()

        }

    }

//    Searching for an element in a heap
//    To find the index of the element you wish to delete, you must perform a search on the heap. Unfortunately, heaps are not designed for fast searches. With a binary search tree, you can perform a search in O(log n) time, but since heaps are built using an array, and the node ordering in an array is different, you can’t even perform a binary search.
//    Complexity: To search for an element in a heap is, in the worst-case, an O(n) operation, since you may have to check every element in the array.

    func index(of element: Element, startingAt i: Int) -> Int? {
      if i >= count {
        return nil // 1
      }
      if sort(element, elements[i]) {
        return nil // 2
      }
      if element == elements[i] {
        return i // 3
      }
        //递归左边
      if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
        return j // 4
      }
        //递归右边
      if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
        return j // 5
      }
      return nil // 6
    }
    /**
     1.If the index is greater than the number of elements in the array, the search failed. Return nil.

     //对于这个第二点的理解 只要是找的元素在当前index后，且优先级高（如果是大顶堆 要查找的比当前大） 则返回nil 即使要查找的值在前面。 具体可以参考 viewController里面的func indexTest() 查找9 从 index=2 即8开始
     2.Check to see if the element you are looking for has higher priority than the current element at index i. If it does, the element you are looking for cannot possibly be lower in the heap.

     3.If the element is equal to the element at index i, return i.

     4.Recursively search for the element starting from the left child of i.

     5.Recursively search for the element starting from the right child of i.

     6.If both searches failed, the search failed. Return nil.
     */

//MARK:堆排序(有点类似删除堆顶元素)
    mutating func heapSort(){

        var k: Int = self.elements.count

        while k > 1 {

            //交换顶部和最后的元素 这样最大（最小）的就去了数组最后面
            elements.swapAt(0, k-1)

            k -= 1

            //相当于从堆顶移除一个元素，数组还剩n-1，n-2个元素...开始从上到下重新堆化
            siftDown(from: 0, to: k)

        }
    }
}
