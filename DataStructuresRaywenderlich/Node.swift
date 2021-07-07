//
//  Node.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2020/12/29.
//

import Foundation

class Node<Value> {

    var value : Value
    //swift结构体不能有递归包含它的存储属性：结构体为值类型，当值类型生成时其引用自身的话则无法确定其大小，所以无法确定开辟空间的大小
    //Value type 'Node<Value>' cannot have a stored property that recursively contains it
    var next : Node?

    init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }

}

extension Node: CustomStringConvertible{

    var description: String{

        guard let next = next else { return "\(value)" }

        return "\(value) -> " + String(describing: next)
    }

}
