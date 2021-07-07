//
//  TrieNode.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/5/19.
//

import Foundation

//这个是不使用字典树，从一个数组中匹配字符串复杂度为 O（k*n）k是数组的个数，n是字符串长度
class EnglishDictionary {

  private var words: [String]
    init(_ word : [String]) {
        words = word
    }
  func words(matching prefix: String) -> [String] {
    return words.filter { $0.hasPrefix(prefix) }
  }

}

class TrieNode<Key:Hashable> {

    var key : Key?//data 根节点可能没有key

    var children : [Key : TrieNode] = [:] //用一个以元素为key的字典来存储其所有的子节点

    weak var parent : TrieNode?

    var isTerminal : Bool = false

    init(_ key : Key? , _ parent : TrieNode?) {
        self.key = key
        self.parent = parent
    }

}


