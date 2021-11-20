//
//  Tries.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/5/20.
//

import Foundation

//“The Trie class is built for all types that adopt the Collection protocol, including String. In addition to this requirement, each element inside the collection must be Hashable. This is required because you’ll be using the collection’s elements as keys for the children dictionary in TrieNode.”

class Tries<CollectionType : Collection>
where CollectionType.Element : Hashable{

    typealias Node = TrieNode<CollectionType.Element>

    private let root = Node(nil, nil)

    init() {}


    public func insert(_ collection : CollectionType){

        var current = root
        //这个element比如是“happy”的“h”，“a”，“p”等等。。。。。。。
        for element in collection {

            //此元素不存在就增加新节点，否则依次往下层跑（例如字典树已经有h，a。2个节点了就跳过）
            if current.children[element] == nil {
                current.children[element] = Node(element, current)
            }

            current = current.children[element]!
        }

        //插入的字符串的最后一个节点
        current.isTerminal = true

    }

    public func contain(_ collection : CollectionType) -> Bool{

        var current = root

        for element in collection {

            guard let child = current.children[element] else {
                
                return false

            }

            current = child
        }

        return current.isTerminal
    }

    public func remove (_ collection : CollectionType){

        var current = root

        //先查找此字符串
        for element in collection {

            guard let child = current.children[element] else {
                //没查到
                return

            }

            current = child
        }

        //不包含此字符串，此字符串只是其子串
        if !current.isTerminal {
            return
        }

        //找到了，将末尾设置为false，用于后面删除判断，此节点可以删除了
        current.isTerminal = false

        //如果此节点还有其他分支，或者当前分支上 不包含其他字符串（如hello 和 hell 最终是需要保存hell的，因此删到o为止）
        while let parent = current.parent, current.children.isEmpty && !current.isTerminal {

            parent.children[current.key!] = nil
            current = parent
        }
    }
}

//RangeReplaceableCollection是为了append方法
extension Tries where CollectionType: RangeReplaceableCollection{
//PrefixMatching
    func collections(staringWith prefix: CollectionType) -> [CollectionType] {

        var current = root

        for element in prefix {

            guard let child = current.children[element] else {
                //没查到
                return []

            }

            current = child
        }

        return collections(staringWith: prefix, after: current)
    }


    func collections(staringWith prefix: CollectionType, after node: Node) -> [CollectionType]{


        var result: [CollectionType] = []

        if node.isTerminal {
            result.append(prefix)
        }

        //遍历字典中所以的子节点
        for child in node.children.values {

            var prefix = prefix
            //相当于新的前缀 
            prefix.append(child.key!)
            //递归添加
            result.append(contentsOf: collections(staringWith: prefix, after: child))

        }

        return result
    }
}
