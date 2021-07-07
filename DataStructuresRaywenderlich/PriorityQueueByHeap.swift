//
//  PriorityQueueByHeap.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/3.
//

import Foundation

struct PriorityQueue<Element: Equatable>:Queue {

    private var heap: Heap<Element>

    init(sort: @escaping (Element,Element) -> Bool, elements: [Element] = []) {


        self.heap = Heap(sort: sort, elements: elements)

    }
    mutating func enqueue(_ element: Element) -> Bool {

        heap.insert(element)
        return true
    }

    mutating func dequeue() -> Element? {

        return heap.remove()
    }

    var isEmpty: Bool{

        return heap.isEmpty
    }

    var peek: Element?{
        return heap.peek()
    }



}
