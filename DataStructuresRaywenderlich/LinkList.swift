//
//  LinkList.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2020/12/29.
//

import Foundation

struct LinkList<Value> {

    var head : Node<Value>?
    var tail : Node<Value>?

    init() {}

    //linklist自定义实现copy on write （cow）
    //array1 = array2都指向 数组1，2
    //array2 append 3
    //array1指向1，2
    //array2指向新的内存123
    private mutating func copyNodes() {

        //为了避免每次调用append等方法都要调用这个
        //O(n)的copyNodes方法，如果当前链表只有一个引用者就不copy
        guard !isKnownUniquelyReferenced(&head) else {
          return
        }

        guard var oldNode = head else {
            return
        }

        head = Node(value: oldNode.value)
        var newNode = head

        while let oldNodeNext = oldNode.next {

            newNode!.next = Node(value: oldNodeNext.value)

            oldNode = oldNodeNext

            newNode = newNode!.next
        }

        tail = newNode
    }

    var isEmpty : Bool {

        return head == nil
    }

    mutating func push(_ value: Value){

        //push头插可以忽略cow，因为他们是共用部分节点
        //list1,list2：1->2->3
        //list1.push(100)= “List1: 100 -> 1 -> 2 -> 3”
        //list2.push(0)= “List2: 0 -> 1 -> 2 -> 3”
//list1:100
//         \
//          \
//          _\｜
//  list2:0 ->1->2->3
        //调不调用效果一样，还是原来的链只是开了个分支的感觉，回忆书上此章节最后一页的图
//        copyNodes()

        head = Node(value: value, next: head)

        if  tail == nil{
            tail = head
        }
    }

    mutating func append(_ value: Value){

        //这样就实现了cow。list2append后会是一条新的list
        copyNodes()
        
        guard !isEmpty else {
            push(value)
            return
        }

        tail!.next = Node(value: value)

        tail = tail!.next
    }

    mutating func node(at index: Int) -> Node<Value>?{


        var currentNode = head
        var currentIndex = 0

        while currentNode != nil && currentIndex < index {

            currentNode = currentNode!.next
            currentIndex += 1
        }

        return currentNode

    }

    @discardableResult
    mutating func insert(_ value : Value, after node: Node<Value>) -> Node<Value> {

        //如果是尾巴（引用类型比较存储的地址值是否相等(是否引用着同一个对象)，使用恒等运算符=== 、!== ）
        guard tail !== node else {
            append(value)
            return tail!
        }
        //不是尾巴node的next是插入的节点。插入节点的next是node的原next
        node.next = Node(value: value, next: node.next)
        return node.next!
    }

    @discardableResult
    mutating func pop() -> Value? {

        defer {
            head = head?.next
//“By moving the head down a node, you’ve effectively removed the first node of the list. ARC will remove the old node from memory once the method finishes, since there will be no more references attached to it. In the event that the list becomes empty, you set tail to nil”
            //移除后如果链表空了
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }

    @discardableResult
    mutating func removeLast() -> Value? {

        guard head != nil else {
            return nil
        }

        guard head?.next != nil else {

            return pop()
        }

        var preNode = head
        var currentNode = head

        while currentNode?.next != nil {

            preNode = currentNode
            currentNode = currentNode?.next

        }

        //去掉最后节点
        preNode?.next = nil
        tail = preNode

        return currentNode?.value
    }

    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        //这个defer很关键，是先返回node.next?.value，然后再node.next = node.next?.next，这样返回的就是被移除的那个节点
      defer {
        if node.next === tail {
          tail = node
        }
        node.next = node.next?.next
      }
      return node.next?.value
    }

}

extension LinkList: CustomStringConvertible{

    var description: String{

        guard let head = head else { return "LinkList is empty" }

        return String(describing: head)
    }

}

//给链表遵守Collection：Sequence协议增加下标等操作
extension LinkList: Collection{

    //要自定义Collection至少需要实现下面的startIndex等方法，而这个index是一个关联类型且遵守Comparable协议，我们自定义如下需实现Comparable协议
    //那么startIndex里面的node是head，endIndex里面的node是tail。那么链表就就和这个下标绑定起来，就可以实现用下标访问了（自己的理解）
    //比较实例大小遵守Comparable重载运算符
    struct Index: Comparable {

        var node: Node<Value>?

        static func == (lhs: Index, rhs: Index) -> Bool {

            //可选项绑定？
            switch (lhs.node, rhs.node) {
            case let (left? , right?):
                return left.next === right.next
            case (nil , nil):
                return true
            default:
                return false
            }


        }

        static func < (lhs: Index, rhs: Index) -> Bool {

            guard lhs != rhs else {
                return false
            }

            //不停的next
            let nodes = sequence(first: lhs.node) { $0?.next}
            return nodes.contains { $0 === rhs.node }
        }

    }

    /**
     Conforming to the Collection Protocol
     /// =====================================
     ///
     /// If you create a custom sequence that can provide repeated access to its
     /// elements, make sure that its type conforms to the `Collection` protocol in
     /// order to give a more useful and more efficient interface for sequence and
     /// collection operations. To add `Collection` conformance to your type, you
     /// must declare at least the following requirements:
     ///
     /// - The `startIndex` and `endIndex` properties
     /// - A subscript that provides at least read-only access to your type's
     ///   elements
     /// - The `index(after:)` method for advancing an index into your collection
     */
    public var startIndex: Index {
      return Index(node: head)
    }
    // 2
    public var endIndex: Index {
      return Index(node: tail?.next)
    }
    // 3
    public func index(after i: Index) -> Index {
      return Index(node: i.node?.next)
    }
    // 4
    public subscript(position: Index) -> Value {
      return position.node!.value
    }
    
}

//MARK:leetCode 160:相交链表
extension LinkList{

    func getIntersectionNode(_ headA: Node<Value>?, _ headB: Node<Value>?) -> Node<Value>? {

        if headA == nil || headB == nil {
            return nil
        }

        var headOne = headA
        var headTwo = headB

        while headOne !== headTwo {

            headOne = headOne == nil ? headB : headOne?.next
            headTwo = headTwo == nil ? headA : headTwo?.next

        }

        return headOne
    }
}
