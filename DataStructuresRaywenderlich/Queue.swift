//
//  Queue.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/1/25.
//

import Foundation
//总结四种方案：
//1.数组实现dequeue时是O(n)，因为需要挪动数组中所有的元素
//2.双向链表实现，主要是链表元素位置不是连续的。这样查找时会消耗额外的时间
//3.ringbuff实现缺点在于数组大小的固定
//4.双栈是比较优秀的，2个数组栈元素位置连续，大小也可变。
public protocol Queue {

    associatedtype Element
    mutating func enqueue(_ element: Element) -> Bool
    mutating func dequeue() -> Element?
    var isEmpty:Bool {get}
    var peek: Element? {get}

}

//MARK:数组实现
//数组实现队列。enqueue如果空间不足扩展时最坏是O(n),平时是O(1),均摊O(1)
//dequeue数组挪动，O(n)
//但是王铮是enqueue时进行数据搬移，Raywenderlich使用双向链表
struct QueueArray<T>:Queue {

    typealias Element = T

    private var array: [T] = []

    var isEmpty: Bool {
       return array.isEmpty
    }

    var peek: T? {

        get {array.first}
    }

    public init(){

    }

    mutating func enqueue(_ element: T) -> Bool {
        array.append(element)
        return true
    }

    mutating func dequeue() -> T? {
        return isEmpty ? nil : array.removeFirst()
    }
}

extension QueueArray: CustomStringConvertible{

    var description: String {
        return array.description
    }

}

//MARK:双向链表实现
class QueueLinkedList<T>: Queue {

    typealias Element = T

    var list = DoublyLinkedList<T>()

    var isEmpty: Bool {
       return list.isEmpty
    }

    public var peek: T? {
      return list.first?.value
    }

    init(){}

    @discardableResult func enqueue(_ element: T) -> Bool {
        list.append(element)
        return true
    }

    @discardableResult func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else {
            return nil
        }
        return list.remove(element)

    }

}

extension QueueLinkedList: CustomStringConvertible {
  public var description: String {
    return list.description
  }
}

//MARK:RingBuffer实现
class QueueRingBuffer<T> : Queue{

    var ringBuff : RingBuffer<T>

    var isEmpty: Bool{
        ringBuff.isEmpty
    }

    var peek: T?{
        if !isEmpty {
           return ringBuff.first
        }else{
            return nil
        }

    }


    typealias Element = T

    init(count : Int) {
        ringBuff = RingBuffer<T>(count: count)
    }

    @discardableResult func enqueue(_ element: T) -> Bool {
        ringBuff.write(element)
    }

    @discardableResult func dequeue() -> T? {
        ringBuff.read()
    }

}
extension QueueRingBuffer: CustomStringConvertible {

  public var description: String {
    String(describing: ringBuff)
  }
}

//MARK:2个栈实现
//主要思路是入栈往右边栈（数组）添加元素
//出栈：仅当左边栈是空的（不为空时直接移左栈元素即可，右栈还可以继续入栈。这时queue的元素为左栈加右栈元素的和），就反转右栈复制到左栈，移除左栈最后的元素。
public struct QueueStack<T> : Queue {

  private var leftStack: [T] = []
  private var rightStack: [T] = []
  public init() {}

  public var isEmpty: Bool {
    leftStack.isEmpty && rightStack.isEmpty
  }

  public var peek: T? {
    !leftStack.isEmpty ? leftStack.last : rightStack.first
  }

  @discardableResult public mutating func enqueue(_ element: T) -> Bool {
    rightStack.append(element)
    return true
  }

  public mutating func dequeue() -> T? {
    if leftStack.isEmpty {
      leftStack = rightStack.reversed()
      rightStack.removeAll()
    }
    return leftStack.popLast()
  }
}

extension QueueStack: CustomStringConvertible {

  public var description: String {
    //queue的元素为左栈加右栈元素的和
    String(describing: leftStack.reversed() + rightStack)
  }
}

