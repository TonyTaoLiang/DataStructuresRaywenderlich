//
//  BinarySearchTree.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/3/24.
//

import Foundation

public struct BinarySearchTree<Element: Comparable>{

    public private(set) var root: BinaryNode<Element>?

    public init(){}

}

extension BinarySearchTree: CustomStringConvertible{

    public var description: String{

        return root?.description ?? "empty tree"
    }

}

extension BinarySearchTree{

    public mutating func insert(_ value: Element){

        root = insert(from: root, value: value)

    }

    public func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>{

        guard let node = node else { return BinaryNode(value: value) }

        if value < node.value {
            //递归左子树
            node.leftChild = insert(from: node.leftChild, value: value)

        } else {

            //递归右子树
            node.rightChild = insert(from: node.rightChild, value: value)

        }
        
        return node
    }

    //参照之前遍历查找的方法（O(n)）

    public func oldContains(_ value: Element) -> Bool{


        guard let root = root else { return false }

        var found = false

        root.traverseInorder {
            if $0 == value {
                found = true
            }
        }

        return found
    }

    //二叉树搜索树的方式 小则左子树 大则右子树
    public func contains(_ value: Element) -> Bool{

        var current = root

        var found = false

        while let node = current {

            if node.value == value {
                found = true
            }

            if value < node.value {
                current = current?.leftChild
            }else{
                current = current?.rightChild
            }
        }

        return found

    }
}

//递归找到节点的最小右子树节点
private extension BinaryNode{

    var min : BinaryNode {

        return leftChild?.min ?? self
    }

}

//删除
extension BinarySearchTree{

    public mutating func remove (_ value: Element){

        root = remove(root, value)

    }

    func remove(_ node: BinaryNode<Element>?, _ value: Element) -> BinaryNode<Element>? {


        guard let node = node else { return nil}


        if value == node.value {

            //1.是子节点
            if node.leftChild == nil && node.rightChild == nil {

                return nil
            }

            //2.有一个子节点
            if node.leftChild == nil{

                return node.rightChild
            }

            if node.rightChild == nil {

                return node.leftChild
            }

            //3.有2个子节点
            //为了符合二叉搜索树的左小右大的规则：首先右子树的最小值替换当前被删除的节点
            node.value = node.rightChild!.min.value
            //将此删除节点当成root，开始删除其右子树最小节点，然后连接上去
            node.rightChild = remove(node.rightChild, node.value)
        } else if (value < node.value){

            node.leftChild = remove(node.leftChild, value)

        } else{

            node.rightChild = remove(node.rightChild, value)
        }

        return node
    }


}

//翻转二叉树
extension BinarySearchTree{
    
    func invertTree(_ root: BinaryNode<Element>?) -> BinaryNode<Element>? {
        
        //我这是跟官方一样的从下到上交换
        if root?.leftChild == nil && root?.rightChild == nil {
            return root
        }

        let leftNode = invertTree(root?.leftChild)
        let rightNode = invertTree(root?.rightChild)

        root?.leftChild = rightNode
        root?.rightChild = leftNode

        return root
        
    }

    //题解：从上到下 是我开始的想法 也好理解一些
    func invertTree2(_ root: BinaryNode<Element>?) -> BinaryNode<Element>? {


        //条件跟我有点不太一样
        if root == nil {return nil}
        let tmp = root?.rightChild;
        root?.rightChild = root?.leftChild;
        root?.leftChild = tmp;
        //递归交换当前节点的 左子树
        invertTree(root?.leftChild);
        //递归交换当前节点的 右子树
        invertTree(root?.rightChild);

        return root

    }
}
