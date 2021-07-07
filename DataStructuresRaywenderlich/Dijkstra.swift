//
//  Dijkstra.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/7/5.
//

import Foundation

//每个顶点的状态1.是不是起始点 2.不是起始点就存它最短的一条边
public enum Visit<T: Hashable> {
    case start
    case edge(Edge<T>)
}

public class Dijkstra<T: Hashable> {

  public typealias Graph = AdjacencyList<T>
  let graph: Graph

  public init(graph: Graph) {
    self.graph = graph
  }

    //MARK: - 辅助方法1
    //依次找回此顶点到初始点的路径
    //参数paths是一个字典：存储了图中所有顶点的一个状态。1.是不是起始点 2.不是起始点就存它最短的一条边
    private func route(to destination: Vertex<T>, with paths:[Vertex<T> : Visit<T>]) -> [Edge<T>]{

        var vertex = destination
        var path : [Edge<T>] = []

        //case .edge(let edge) = visit是可选项绑定？ 如果不是.strat就将其edge给出去
        while let visit = paths[vertex], case .edge(let edge) = visit {

            path = [edge] + path
            vertex = edge.source

        }

        return path
    }

    //MARK: - 辅助方法2
    //计算此顶点到初始点的距离值
    private func distance(to destination: Vertex<T>,
                          with paths: [Vertex<T> : Visit<T>]) -> Double {

        let path = route(to: destination, with: paths)

        let flatMap = path.compactMap{$0.weight}

        let result = flatMap.reduce(0, +)

        return result
    }

    //找出所有的顶点的一个路径（字典）
    public func shortestPath(from start: Vertex<T>) -> [Vertex<T> : Visit<T>] {

        var paths: [Vertex<T> : Visit<T>] = [start : .start]

        //创建一个小顶堆：这样每次dequeue都是当前最短的一个顶点
        var priorityQueue = PriorityQueue {
            self.distance(to: $0, with: paths) <
            self.distance(to: $1, with: paths)
        }


        priorityQueue.enqueue(start)

        //每次顶出最小的一个
        while let vertex = priorityQueue.dequeue() {

            //遍历这个顶点所有的outGoing edge
            for edge in graph.edges(from: vertex) {

                guard let weight = edge.weight else { // 3
                      continue
                    }

                if paths[edge.destination] == nil || distance(to: vertex, with: paths) + weight < distance(to: edge.destination, with: paths) {

                    paths[edge.destination] = .edge(edge)
                    //这里是不是会重复入列？比如附件图的B点？重复入列也没关系？：经过下面入堆顺序()的打印结果如下，确实是顶点B反复入堆，这样也没关系
                    /**(最开始是A出堆，A的outgoing B，F，G 依次入堆，然后是最短的顶端的G出堆，G的outgoing是C入堆，依次类推)
                     入堆===B
                     入堆===F
                     入堆===G
                     入堆===C
                     入堆===E
                     入堆===B
                     入堆===B
                     入堆===D
                     */
                    priorityQueue.enqueue(edge.destination)
                    print("入堆===\(edge.destination.data)")

                }


            }

        }


        return paths
    }

    public func shortestPath(to destination: Vertex<T>,
                             paths: [Vertex<T> : Visit<T>]) -> [Edge<T>] {

        return route(to: destination, with: paths)
    }
}
