//
//  AVLTree.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/4/11.
//

import Foundation
import UIKit
public struct AVLTree<Element: Comparable> {

  public private(set) var root: AVLNode<Element>?

  public init() {}
}

extension AVLTree: CustomStringConvertible {

  public var description: String {
    guard let root = root else { return "empty tree" }
    return String(describing: root)
  }
}

private extension AVLNode {

  var min: AVLNode {
    return leftChild?.min ?? self
  }
}

extension AVLTree{


    public mutating func insert(_ value: Element) {
      root = insert(from: root, value: value)
    }

    private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {
        guard let node = node else {
            return AVLNode(value: value)
        }
        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }

        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode

    }

    public mutating func remove(_ value: Element) {
      root = remove(node: root, value: value)
    }
    
    private func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
      guard let node = node else {
        return nil
      }
      if value == node.value {
        if node.leftChild == nil && node.rightChild == nil {
          return nil
        }
        if node.leftChild == nil {
          return node.rightChild
        }
        if node.rightChild == nil {
          return node.leftChild
        }
        //右子树的最小值顶替，然后删除最小的这个节点
        node.value = node.rightChild!.min.value
        node.rightChild = remove(node: node.rightChild, value: node.value)
      } else if value < node.value {
        node.leftChild = remove(node: node.leftChild, value: value)
      } else {
        node.rightChild = remove(node: node.rightChild, value: value)
      }
      let balancedNode = balanced(node)
      balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
      return balancedNode
    }

    //左旋
    //我的理解是传入的这个node是要旋转的中心点的父节点
    public func leftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        

        let rotate = node.rightChild!

        node.rightChild = rotate.leftChild

        rotate.leftChild = node

        rotate.height = max(rotate.leftHeight, rotate.rightHeight) + 1

        node.height = max(node.leftHeight, node.rightHeight) + 1

        return rotate
    }
    //右旋
    private func rightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
      let pivot = node.leftChild!
      node.leftChild = pivot.rightChild
      pivot.rightChild = node
      node.height = max(node.leftHeight, node.rightHeight) + 1
      pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1
      return pivot
    }

    private func rightLeftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        guard let rightNode = node.rightChild else { return node }

        node.rightChild = rightRotate(rightNode)

        return leftRotate(node)

    }

    private func leftRightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {
      guard let leftChild = node.leftChild else {
        return node
      }
      node.leftChild = leftRotate(leftChild)
      return rightRotate(node)
    }

   
    //判断是否平衡，以及看下图balanceFactor是否是-1决定接下来该如何旋转，
    //#imageLiteral(resourceName: "哈哈 12.png")
    private func balanced(_ node: AVLNode<Element>) -> AVLNode<Element> {

        switch node.balanceFactor {
        case 2://左子树重
            if let leftChild = node.leftChild , leftChild.balanceFactor == -1{
                return leftRightRotate(node)
            }else{
                return rightRotate(node)
            }
        case -2://右子树重

            if let rightChild = node.rightChild , rightChild.balanceFactor == 1 {
                return rightLeftRotate(node)
            }else{
                return leftRotate(node)
            }
        default:
            return node
        }

    }
}
