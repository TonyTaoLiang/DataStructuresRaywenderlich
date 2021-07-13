//
//  ViewController.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2020/12/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.linkListPart()

        self.stackPart()

        self.queueLinkedListPart()

        self.queueRingBufferPart()

        self.DepthFirstTraversal()

        self.EachLevelOrder()

        self.searchTree()

        print(tree)

        tree.traverseInorder {
            print($0)
        }
    
        self.insertBinarySearchTree()

        print(bst)

        //翻转二叉搜索树
        invertTree()
        
        //删除二叉搜索树
        removeBST()

        //AVL自平衡树
        avlTreeAdd()
        avlTreeRemove()

        //字典树
        tries()
        triesRemove()
        triesPrefixMatch()

        //二分查找
        binarySearch()

        //堆
        heap()
        indexTest()

        //优先级队列（堆）
        priorityQueueHeap()

        //冒泡
        bubbleSort()

        //选择排序
        selectionSort()

        //插入排序
        insertionSort()

        //归并排序
        mergeSort()

        //最后一个pivot
        quicksortLomuto()

        //第一个Hoare’s partitioning
        quicksortHoare()

        //三选一pivot优化
        quickSortMedian()

        //quickDutchFlag
        quickDutchFlag()

        //基数排序
        radixSort()

        //计数排序
        countingSort()

        //两数之和
        twoSum()

        //邻接表(里面带广度搜索)
        creatAdjacencyList()

        //邻接矩阵(里面带深度搜索)
        creatAdjacencyMatrix()

        //最短路径
        Dijkstra()

        //最小生成树
        prim()

        //hash运用1
        hashTable1()
    }

}

extension ViewController{

    //MARK:LinkList
    func linkListPart(){

        let node1 = Node(value: 1)
        let node2 = Node(value: 2)
        let node3 = Node(value: 3)

        node1.next = node2
        node2.next = node3

        //        print(node1)

        //        let linkList = LinkList<String>()

        //        print(linkList)

        var linkListInt = LinkList<Int>()

        linkListInt.push(3)
        linkListInt.push(2)
        linkListInt.push(1)

        print(linkListInt)

        linkListInt.append(4)

        print(linkListInt)

        let middleNode = linkListInt.node(at: 1)
        linkListInt.insert(-1, after: middleNode!)

        print(linkListInt)

        linkListInt.pop()

        print(linkListInt)

        let last = linkListInt.removeLast()

        print("removeLast\(linkListInt)\nlastvalue is \(last!)")


        let middleNode2 = linkListInt.node(at: 0)
        let removedValue = linkListInt.remove(after: middleNode2!)

        print("removeAt\(linkListInt)\nremovevalue is \(removedValue!)")


        //"using collection"协议
        var list = LinkList<Int>()
        for i in 0...9 {
            list.append(i)
        }

        print("List: \(list)")
        print("First element: \(list[list.startIndex])")
        print("Array containing first 3 elements: \(Array(list.prefix(3)))")
        print("Array containing last 3 elements: \(Array(list.suffix(3)))")

        let sum = list.reduce(0, +)
        print("Sum of all values: \(sum)")

        //MARK:COW
        var list1 = LinkList<Int>()
        list1.append(1)
        list1.append(2)
        var list2 = list1
        print("List1: \(list1)")
        print("List2: \(list2)")

        print("After appending 3 to list2")
        list2.append(3)
        print("List1: \(list1)")
        print("List2: \(list2)")
    }

    func stackPart(){

        //MARK:Stack
        var stack = Stack<Int>()
        stack.push(1)
        stack.push(2)
        stack.push(3)
        stack.push(4)

        print(stack)

        if let poppedElement = stack.pop() {
            assert(4 == poppedElement)
            print("Popped: \(poppedElement)")
        }

        let array = ["A", "B", "C", "D"]
        
        var stack2 = Stack(array)
        print(stack2)
        stack2.pop()
        print(stack2)

        var stack3: Stack = [1.0, 2.0, 3.0, 4.0]
        print(stack3)
        stack3.pop()
    }

    func queueLinkedListPart() {
        let queue = QueueLinkedList<String>()
        queue.enqueue("Ray")
        queue.enqueue("Brian")
        queue.enqueue("Eric")
        queue.dequeue()
        print(queue)
        print(queue.peek!)
    }

    func queueRingBufferPart() {

        print("开始循环列表------")
        let queue = QueueRingBuffer<String>(count: 3)
        queue.enqueue("Ray")
        queue.enqueue("Brian")
        queue.enqueue("Eric")
        print(queue)
        print(queue.peek!)

        print("后------")

        queue.dequeue()
        queue.dequeue()
        queue.dequeue()

        print(queue)
        print(queue.peek)
    }

    //MARK:TreeNode

    func treeNode() {

        let Beverages = TreeNode("Beverages")// [ˈbɛvərɪdʒɪz]饮料

        let hot = TreeNode("Hot")

        let cold = TreeNode("cold")

        Beverages.add(hot)

        Beverages.add(cold)
    }

    //MARK:Depth-first traversal深度优先遍历
    //先创建一个树
    func makeBeverageTree() -> TreeNode<String> {
        let tree = TreeNode("Beverages")

        let hot = TreeNode("hot")
        let cold = TreeNode("cold")

        let tea = TreeNode("tea")
        let coffee = TreeNode("coffee")
        let chocolate = TreeNode("cocoa")

        let blackTea = TreeNode("black")
        let greenTea = TreeNode("green")
        let chaiTea = TreeNode("chai")

        let soda = TreeNode("soda")
        let milk = TreeNode("milk")

        let gingerAle = TreeNode("ginger ale")
        let bitterLemon = TreeNode("bitter lemon")

        tree.add(hot)
        tree.add(cold)

        hot.add(tea)
        hot.add(coffee)
        hot.add(chocolate)

        cold.add(soda)
        cold.add(milk)

        tea.add(blackTea)
        tea.add(greenTea)
        tea.add(chaiTea)

        soda.add(gingerAle)
        soda.add(bitterLemon)

        return tree
    }


    func DepthFirstTraversal() {

        let beverages = makeBeverageTree()

        //尾随闭包
        beverages.forEachDepthFirst {
            //$0即是当前节点
            //func forEachDepthFirst(visit:(TreeNode) -> Void){ visit(self) .....}
            print($0.value)
        }

    }

    func EachLevelOrder() {

        let beverages = makeBeverageTree()

        beverages.forEachLevelOrder {
            
            print($0.value)
        }
        
    }

    func searchTree(){

        let beverages = makeBeverageTree()

        if let searchResult1 = beverages.search("ginger ale") {
            print("Found node: \(searchResult1.value)")
        }

        if let searchResult2 = beverages.search("WKD Blue") {
            print(searchResult2.value)
        } else {
            print("Couldn't find WKD Blue")
        }
    }

    var tree: BinaryNode<Int> {
        let zero = BinaryNode(value: 0)
        let one = BinaryNode(value: 1)
        let five = BinaryNode(value: 5)
        let seven = BinaryNode(value: 7)
        let eight = BinaryNode(value: 8)
        let nine = BinaryNode(value: 9)

        seven.leftChild = one
        one.leftChild = zero
        one.rightChild = five
        seven.rightChild = nine
        nine.leftChild = eight

        return seven
    }

    //MARK:BinarySearchTree
    func insertBinarySearchTree() {
        var bst = BinarySearchTree<Int>()
          for i in 0..<5 {
            bst.insert(i)
          }
        print(bst)

    }


    var bst : BinarySearchTree<Int>{

        var bst = BinarySearchTree<Int>()
        bst.insert(3)
        bst.insert(1)
        bst.insert(4)
        bst.insert(0)
        bst.insert(2)
        bst.insert(5)

        return bst
    }

    func invertTree(){

        let root = bst.invertTree(bst.root)

        print("Tree after invertTree")

        print(bst)

        print("Tree after invertTree root = \(root!.value)")

    }

    func removeBST(){
        var bst = BinarySearchTree<Int>()
        bst.insert(3)
        bst.insert(1)
        bst.insert(4)
        bst.insert(0)
        bst.insert(2)
        bst.insert(5)

        bst.remove(3)
        print("Tree after removing root:")
        print(bst)
        
    }

    //MARK:AVL树
    func avlTreeAdd(){

        var tree = AVLTree<Int>()
        for i in 1..<7 {
            tree.insert(i)
        }
        print(tree)
    }

    func avlTreeRemove() {
        var tree = AVLTree<Int>()
        tree.insert(15)
        tree.insert(10)
        tree.insert(16)
        tree.insert(18)
        print(tree)
        tree.remove(10)
        print(tree)
    }

    //MARK:字典树
    func tries(){

        let trie = Tries<String>()
        trie.insert("cute")
        if trie.contain("cut") {
            print("cute is in the trie")
        }else{
            print("Not in the trie")
        }
    }

    func triesRemove(){

        let trie = Tries<String>()
        trie.insert("cut")
        trie.insert("cute")

        print("\n*** Before removing ***")
        assert(trie.contain("cut"))
        print("\"cut\" is in the trie")
        assert(trie.contain("cute"))
        print("\"cute\" is in the trie")

        print("\n*** After removing cut ***")
//        trie.remove("cut")
//        assert(!trie.contain("cut"))
//        assert(trie.contain("cute"))
//        print("\"cute\" is still in the trie")

        trie.remove("cute")
        assert(trie.contain("cut"))
        assert(!trie.contain("cute"))
        print("\"cut\" is still in the trie")
    }

    func triesPrefixMatch(){

        let trie = Tries<String>()
        trie.insert("car")
        trie.insert("card")
        trie.insert("care")
        trie.insert("cared")
        trie.insert("cars")
        trie.insert("carbs")
        trie.insert("carapace")
        trie.insert("cargo")

        print("\nCollections starting with \"car\"")
        let prefixedWithCar = trie.collections(staringWith: "car")
        print(prefixedWithCar)

        print("\nCollections starting with \"care\"")
        let prefixedWithCare = trie.collections(staringWith: "care")
        print(prefixedWithCare)

    }

    //MARK:二分查找
    func binarySearch() {
        let array = [1, 5, 15, 17, 19, 22, 24, 31, 105, 150]

        let search31 = array.firstIndex(of: 31)

        let binarySearch31 = array.binarySearch(for: 31)

        print("index(of:): \(String(describing: search31))")
        print("binarySearch(for:): \(String(describing: binarySearch31))")
    }

    //MARK:堆
    func heap() {

        var heap = Heap(sort: >, elements: [5,8,7,4,3,1,2,6])

//        while !heap.isEmpty {
//          print(heap.remove()!)
//        }

        heap.heapSort()

        for element in heap.elements {
            print(element)
        }

    }

    //index方法的测试
    func indexTest(){

        let heap = Heap(sort: >, elements: [10,9,8,6,5,7,4,3])
        print(heap.index(of: 9, startingAt: 2) as Any)
    }

    //MARK:优先级队列（堆）
    func priorityQueueHeap(){

        var priorityQueue = PriorityQueue(sort: >, elements: [1,12,3,4,1,6,8,7])
        while !priorityQueue.isEmpty {
            print(priorityQueue.dequeue()!)
        }
    }

    func bubbleSort() {
        var array = [9, 4, 10, 3]
        print("Original: \(array)")
        let bubble = BubbleSort()
        bubble.bubbleSort(&array)
        print("Bubble sorted: \(array)")
    }


    func selectionSort() {

        var array = [9, 4, 10, 3]
        let selectionSort = SelectionSort()
        print("Original: \(array)")
        selectionSort.selectionSort(&array)
        print("Selection sorted: \(array)")

    }

    func insertionSort() {
        var array = [9, 4, 10, 3]
        let insertionSort = InsertionSort()
        print("Original: \(array)")
        insertionSort.insertionSort(&array)
        print("Insertion sorted: \(array)")
    }

    func mergeSort() {

        let array = [7, 2, 6, 3, 9]
        let mergeSort = MergeSort()
        print("Original: \(array)")
        print("Merge sorted: \(mergeSort.mergeSort(array))")

    }

    func quicksortLomuto() {
        var list = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
        DataStructuresRaywenderlich.quicksortLomuto(&list, low: 0, high: list.count - 1)
        print(list)
    }

    func quicksortHoare() {

        var list2 = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
        DataStructuresRaywenderlich.quicksortHoare(&list2, low: 0, high: list2.count - 1)
        print(list2)
        

    }

    func quickSortMedian() {

        var list3 = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
        DataStructuresRaywenderlich.quickSortMedian(&list3, low: 0, high: list3.count - 1)
        print(list3)

    }

    func quickDutchFlag(){
        var list4 = [12, 0, 3, 9, 2, 21, 18, 27, 1, 5, 8, -1, 8]
        quicksortDutchFlag(&list4, low: 0, high: list4.count - 1)
        print(list4)
    }

    func radixSort(){

        var array = [88, 410, 1772, 20]
        print("Original array: \(array)")
        array.radixSort()
        print("Radix sorted: \(array)")

    }

    func countingSort(){

        var array = [2, 5, 3, 0, 2, 3, 0, 3]
        print("Original array: \(array)")
        array.countingSort()
        print("Counting sorted: \(array)")

    }

    func twoSum() {

//        let array = [2,7,11,15] //9
//        let array = [3,2,4] //6
        let array = [-3,4,3,90] //0
        let result = array.twoSum(array, 0)
        print("twoSum: \(result)")
    }

    //邻接表
    func creatAdjacencyList() {

        let graph = AdjacencyList<String>()

        let singapore = graph.createVertex(data: "Singapore")
        let tokyo = graph.createVertex(data: "Tokyo")
        let hongKong = graph.createVertex(data: "Hong Kong")
        let detroit = graph.createVertex(data: "Detroit")
        let sanFrancisco = graph.createVertex(data: "San Francisco")
        let washingtonDC = graph.createVertex(data: "Washington DC")
        let austinTexas = graph.createVertex(data: "Austin Texas")
        let seattle = graph.createVertex(data: "Seattle")

        graph.add(.undirected, from: singapore, to: hongKong, weight: 300)
        graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
        graph.add(.undirected, from: hongKong, to: tokyo, weight: 250)
        graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
        graph.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
        graph.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
        graph.add(.undirected, from: detroit, to: austinTexas, weight: 50)
        graph.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
        graph.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
        graph.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
        graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
        graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

        print(graph.description)

        print("--------------------------------")
        print("How much is a flight from Singapore to Tokyo?")
        print(graph.weight(from: singapore, to: tokyo)!)

        print("--------------------------------")
        print("San Francisco Outgoing Flights:")
        for edge in graph.edges(from: sanFrancisco) {
          print("from: \(edge.source) to: \(edge.destination)")
        }

        print("--------------------------------")
        print("Breadth-First Search:")
        let vertexs = graph.breadthFirstSearch(from: singapore)
        vertexs.forEach { vertex in
          print(vertex)
        }
        print("--------------------------------")
    }

    //邻接矩阵
    func creatAdjacencyMatrix() {

        let graph = AdjacencyMatrix<String>()

        var singapore = graph.createVertex(data: "Singapore")
        let tokyo = graph.createVertex(data: "Tokyo")
        let hongKong = graph.createVertex(data: "Hong Kong")
        let detroit = graph.createVertex(data: "Detroit")
        let sanFrancisco = graph.createVertex(data: "San Francisco")
        let washingtonDC = graph.createVertex(data: "Washington DC")
        let austinTexas = graph.createVertex(data: "Austin Texas")
        let seattle = graph.createVertex(data: "Seattle")

        graph.add(.undirected, from: singapore, to: hongKong, weight: 300)
        graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
        graph.add(.undirected, from: hongKong, to: tokyo, weight: 250)
        graph.add(.undirected, from: tokyo, to: detroit, weight: 450)
        graph.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
        graph.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
        graph.add(.undirected, from: detroit, to: austinTexas, weight: 50)
        graph.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
        graph.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
        graph.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
        graph.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
        graph.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

        print(graph.description)

        print("--------------------------------")
        print("San Francisco Outgoing Flights:")
        for edge in graph.edges(from: sanFrancisco) {
          print("from: \(edge.source) to: \(edge.destination)")
        }

        print("--------------------------------")
        print("Depth-First Search:")
        let vertexs = graph.depthFirstSearch(from: singapore)
        vertexs.forEach { vertex in
          print(vertex)
        }
        print("--------------------------------")
        print("Depth-FirstRecursion Search:")
        let vertexsRecursion = graph.depthFirstSearchRecursion(from: singapore)
        vertexsRecursion.forEach { vertex in
            print(vertex)
        }
        print("--------------------------------")
    }


    //最短路径
    func Dijkstra() {

        let graph = AdjacencyList<String>()

        let a = graph.createVertex(data: "A")
        let b = graph.createVertex(data: "B")
        let c = graph.createVertex(data: "C")
        let d = graph.createVertex(data: "D")
        let e = graph.createVertex(data: "E")
        let f = graph.createVertex(data: "F")
        let g = graph.createVertex(data: "G")
        let h = graph.createVertex(data: "H")

        graph.add(.directed, from: a, to: b, weight: 8)
        graph.add(.directed, from: a, to: f, weight: 9)
        graph.add(.directed, from: a, to: g, weight: 1)
        graph.add(.directed, from: b, to: f, weight: 3)
        graph.add(.directed, from: b, to: e, weight: 1)
        graph.add(.directed, from: f, to: a, weight: 2)
        graph.add(.directed, from: h, to: f, weight: 2)
        graph.add(.directed, from: h, to: g, weight: 5)
        graph.add(.directed, from: g, to: c, weight: 3)
        graph.add(.directed, from: c, to: e, weight: 1)
        graph.add(.directed, from: c, to: b, weight: 3)
        graph.add(.undirected, from: e, to: c, weight: 8)
        graph.add(.directed, from: e, to: b, weight: 1)
        graph.add(.directed, from: e, to: d, weight: 2)

        let dijkstra = DataStructuresRaywenderlich.Dijkstra(graph: graph)
        let pathsFromA = dijkstra.shortestPath(from: a) // 1
        let path = dijkstra.shortestPath(to: d, paths: pathsFromA) // 2
        for edge in path { // 3
          print("\(edge.source) --(\(edge.weight ?? 0.0))--> \(edge.destination)")
        }
    }

    //最小生成树
    func prim(){

        let graph = AdjacencyList<Int>()
        let one = graph.createVertex(data: 1)
        let two = graph.createVertex(data: 2)
        let three = graph.createVertex(data: 3)
        let four = graph.createVertex(data: 4)
        let five = graph.createVertex(data: 5)
        let six = graph.createVertex(data: 6)

        graph.add(.undirected, from: one, to: two, weight: 6)
        graph.add(.undirected, from: one, to: three, weight: 1)
        graph.add(.undirected, from: one, to: four, weight: 5)
        graph.add(.undirected, from: two, to: three, weight: 5)
        graph.add(.undirected, from: two, to: five, weight: 3)
        graph.add(.undirected, from: three, to: four, weight: 5)
        graph.add(.undirected, from: three, to: five, weight: 6)
        graph.add(.undirected, from: three, to: six, weight: 4)
        graph.add(.undirected, from: four, to: six, weight: 2)
        graph.add(.undirected, from: five, to: six, weight: 6)

        let (cost,mst) = Prim().produceMinimumSpanningTree(for: graph)
        print("cost: \(cost)")
        print("mst:")
        print(mst)
    }

    //hashTable使用1
    func hashTable1(){

        let array = ["www.baidu.com",
                     "www.baidu.com",
                     "www.baidu.com",
                     "www.aiqiyi.com",
                     "www.aiqiyi.com",
                     "www.tencent.com"]
        let hash = HashTable<String>()
        print(hash.hashSort(array: array))
    }
}
