//
//  Stack.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/1/15.
//

import Foundation

public struct Stack<Element>{

    private var storage : [Element] = []

    public init(){}

    public init(_ elements: [Element]) {
      storage = elements
    }
    
    public mutating func push(_ element: Element) {
      storage.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
      return storage.popLast()
    }

    public func peek() -> Element? {
     return storage.last
    }

    public var isEmpty: Bool {
      return peek() == nil
    }
}

extension Stack: ExpressibleByArrayLiteral {
    //可以这样初始化“var stack: Stack = [1.0, 2.0, 3.0, 4.0]”
  public init(arrayLiteral elements: Element...) {
    storage = elements
  }
}

extension Stack: CustomStringConvertible{

    public var description: String{

        let topDivider = "----top----\n"

        let bottomDivider = "\n-----------"

        let stackElements = storage.map {"\($0)"}.reversed().joined(separator: "\n")

        return topDivider + stackElements + bottomDivider

    }

}
