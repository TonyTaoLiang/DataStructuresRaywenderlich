//
//  Prim.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/7/6.
//

import Foundation

//最小生成树
//1.把原Graph上所有的顶点复制到新图。然后慢慢的用最短路径连线
//2.每次到一个点就将此顶点的所有边（除去edge.destion已经访问过了的边，避免已经是生成树里面的边再次入堆）入堆
//3.从堆中dequeue的时候，如果此edge.destion已经访问过了，那么直接continue，因为说明要么此边已是属于spanning的一条边，或者此边的destion已经有了一条短路径的边了


class Prim<T: Hashable> {

    public typealias Graph = AdjacencyList<T>
    public init() {}

    //MARK: - 辅助方法1（这个方法不太顶）
    //复制顶点到一个新图
    internal func copyVertices(from graph: Graph, to graph2: Graph) {

        for vertex in graph.vertices {

            graph2.createVertex(data: vertex.data)
        }

    }

    //MARK: - 辅助方法2
    //每到一个顶点将此顶点可能的边入堆
    internal func addAvailableEdges(for vertex: Vertex<T>,
                                    in graph: Graph,
                                    check visited: Set<Vertex<T>>,
                                    to priorityQueue: inout PriorityQueue<Edge<T>>) {

        for edge in graph.edges(from: vertex) {

            if !visited.contains(edge.destination) {

                priorityQueue.enqueue(edge)
            }

        }

    }


    public func produceMinimumSpanningTree(for graph: Graph)
        -> (cost: Double, mst: Graph) {


        var mst: Graph = Graph()
        var cost: Double = 0.0
        var visited: Set<Vertex<T>> = [] // 4
        var priorityQueue = PriorityQueue<Edge<T>>(sort: { // 5
            $0.weight ?? 0.0 < $1.weight ?? 0.0
          })

        //下面这个按书上来的copyVertices方法不行啊 打印出的结果不对，要按下面代码里的这个才行
        //copyVertices(from: graph, to: mst)
        //这个AdjacencyList里的方法才可以，但感觉跟上面一个没什么区别，有点不太明白？
        mst.copyVertices(from: graph)
        //起始点（空图return）
        guard let start = graph.vertices.first else { return (cost: cost, mst: mst) }

        visited.insert(start)

        //起始点所有的边入堆
        addAvailableEdges(for: start, in: graph, check: visited, to: &priorityQueue)


        //开始出堆直到堆中没有了边 即结束
        while let edge = priorityQueue.dequeue() {

            //从堆中dequeue的时候，如果此edge.destion已经访问过了，那么直接continue，因为说明要么此边已是属于spanning的一条边，或者此边的destion已经有了一条短路径的边了
            guard !visited.contains(edge.destination) else {
                continue
            }

            cost += edge.weight ?? 0.0

            visited.insert(edge.destination)

            //画上这条最短路径
            mst.add(.undirected, from: edge.source, to: edge.destination, weight: edge.weight)

            //这个顶点的outgoing开始入堆
            addAvailableEdges(for: edge.destination, in: graph, check: visited, to: &priorityQueue)

        }

        return (cost: cost, mst: mst)
    }
}


