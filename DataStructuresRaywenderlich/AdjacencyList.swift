//
//  AdjacencyList.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/29.
//
//MARK: - 邻接表
import Foundation

public class AdjacencyList<T>: Graph{

    //用一个字典（散列表？）来存储每个顶点的边
    var adjacencies: [Vertex<T> : [Edge<T>]] = [:]

    //计算属性返回所有的顶点
    public var vertices: [Vertex<T>] {
      Array(adjacencies.keys)
    }

    public func copyVertices(from graph: AdjacencyList) {
      for vertex in graph.vertices {
        adjacencies[vertex] = []
      }
    }
    
    @discardableResult public func createVertex(data: T) -> Vertex<T>{
        //初始化顶点以及字典的边。每个顶点的index就是字典的对数（有一个顶点就有一对）
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }

    public func addDirectedEdge(from source: Vertex<T>,
                         to destination: Vertex<T>,
                         weight: Double?){

        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)

    }

    public func add(_ edge: EdgeType, from source: Vertex<T>,
             to destination: Vertex<T>,
             weight: Double?){

        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        default:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }

    public func edges(from source: Vertex<T>) -> [Edge<T>]{

        return adjacencies[source] ?? []

    }

    public func weight(from source: Vertex<T>,
                       to destination: Vertex<T>) -> Double?{

        return edges(from: source)
            .first {$0.destination == destination}?
            .weight

    }
}

extension AdjacencyList: CustomStringConvertible {

  public var description: String {
    var result = ""
    for (vertex, edges) in adjacencies { // 1
      var edgeString = ""
      for (index, edge) in edges.enumerated() { // 2
        if index != edges.count - 1 {
          edgeString.append("\(edge.destination), ")
        } else {
          edgeString.append("\(edge.destination)")
        }
      }
      result.append("\(vertex) ---> [ \(edgeString) ]\n") // 3
    }
    return result
  }
}
