//
//  DoublyLinkedList.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/1/26.
//

import Foundation

public class DoubleNode<T> {

  public var value: T
  public var next: DoubleNode<T>?
  public var previous: DoubleNode<T>?

  public init(value: T) {
    self.value = value
  }
}

extension DoubleNode:CustomDebugStringConvertible{
    public var debugDescription: String {
        String(describing: value)
    }
}

public class DoublyLinkedList<T>{

    private var head: DoubleNode<T>?
    private var tail: DoubleNode<T>?

    init() {}

    public var isEmpty: Bool{
        head == nil
    }

    public var first: DoubleNode<T>?{
        head
    }

    public func append(_ value: T) {

        let newNode = DoubleNode(value: value)

        guard let tailNode = tail else {

            head = newNode
            tail = newNode
            return
        }

        newNode.previous = tailNode
        tailNode.next = newNode
        tail = newNode
    }

    public func remove(_ node: DoubleNode<T>) -> T {

        let pre = node.previous
        let next = node.next

        //先处理如果是头
        if let preNode = pre {

            preNode.next = next

        }else{

            head = next
            
        }

        next?.previous = pre

        //再处理如果是尾巴
        if next == nil {
            tail = pre
        }

        node.previous = nil
        node.next = nil

        return node.value
    }
}

extension DoublyLinkedList: CustomStringConvertible {

  public var description: String {
    var string = ""
    var current = head
    while let node = current {
      string.append("\(node.value) -> ")
      current = node.next
    }
    return string + "end"
  }
}

//使双向链表也可以进行next迭代
public class LinkedListIterator<T>: IteratorProtocol {

    private var current: DoubleNode<T>?

    init(node: DoubleNode<T>?) {
        current = node
    }

    public func next() -> DoubleNode<T>? {
      defer { current = current?.next }
      return current
    }

}

//创建迭代器
extension DoublyLinkedList: Sequence {
    //返回不透明类型some：返回一个遵守IteratorProtocol协议的对象
    public func makeIterator() -> some IteratorProtocol {
        LinkedListIterator(node: head)
    }
}
