//
//  TreeNode.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/3/2.
//

import Foundation

public class TreeNode<T> {

    var value : T

    var children : [TreeNode] = []

    init(_ value: T) {
        self.value = value
    }

    public func add(_ child: TreeNode){

        children.append(child)
    }
}


//Depth-first traversal深度优先遍历
extension TreeNode{

    public func forEachDepthFirst(visit:(TreeNode) -> Void){

        visit(self)//调用一下闭包，后面调用forEachDepthFirst时会打印闭包参数即是打印此节点的值：node.forEachDepthFirst{print"$0.value"}

        //递归调用
        children.forEach {
            $0.forEachDepthFirst(visit: visit)
        }

    }
}

//Level-order traversal广度优先遍历
extension TreeNode{

    public func forEachLevelOrder(visit: (TreeNode) -> Void){

        visit(self)

        //非常巧妙的用了一个队列，不能用栈，因为栈是先进后出，脑海中想象一下入栈的图，这样打印起来就不是每一层每一层的打印
        var queue = QueueArray<TreeNode>()

        //第一层入列
        children.forEach {
            queue.enqueue($0)
        }

        //第一层开始出列，然后里面开始第二层入列依此类推
        while let node = queue.dequeue() {

            visit(node)

            node.children.forEach {queue.enqueue($0)}
        }
    }

}

//查找
extension TreeNode where T: Equatable{

    public func search(_ value: T) -> TreeNode?{

        var result : TreeNode?

        forEachLevelOrder {

            if $0.value == value {

                result = $0

            }
        }

        return result
    }


}
