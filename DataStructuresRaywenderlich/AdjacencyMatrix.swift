//
//  AdjacencyMatrix.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/29.
//

//MARK: - 邻接矩阵
import Foundation


public class AdjacencyMatrix<T>: Graph{

    var vertexs: [Vertex<T>] = []
    //二维数组表示权重
    var weights: [[Double?]] = []

    public func createVertex(data: T) -> Vertex<T>{

        //1.每个顶点的index就是顶点数组的个数
        let vertex = Vertex(index: vertexs.count, data: data)
        vertexs.append(vertex)

        //2.每一个顶点可以看成是一个桶，加了一个顶点那么columns + 1 即桶中的球加一
        for i in 0 ..< weights.count{
            weights[i].append(nil)
        }

        //3.加了一个顶点，就加一个桶，即矩阵扩大（row），上面第二步扩大了列
        let row = [Double?](repeating: nil, count: vertexs.count)
        weights.append(row)

        return vertex
    }

    public func addDirectedEdge(from source: Vertex<T>,
                                to destination: Vertex<T>, weight: Double?) {

        //二维数组中有值则表示有边了
        weights[source.index][destination.index] = weight
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
    public func edges(from source: Vertex<T>) -> [Edge<T>] {

        var edges:[Edge<T>] = []

        for column in 0 ..< weights.count {

            if let weight = weights[source.index][column] {

                let edge = Edge(source: source, destination: vertexs[column], weight: weight)
                edges.append(edge)
            }

        }

        return edges

    }

    public func weight(from source: Vertex<T>,
                       to destination: Vertex<T>) -> Double? {

       return weights[source.index][destination.index]
    }

}

extension AdjacencyMatrix: CustomStringConvertible {

  public var description: String {
    // 1
    let verticesDescription = vertexs.map { "\($0)" }
                                      .joined(separator: "\n")
    // 2
    var grid: [String] = []
    for i in 0..<weights.count {
      var row = ""
      for j in 0..<weights.count {
        if let value = weights[i][j] {
          row += "\(value)\t"
        } else {
          row += "ø\t\t"
        }
      }
      grid.append(row)
    }
    let edgesDescription = grid.joined(separator: "\n")
    // 3
    return "\(verticesDescription)\n\n\(edgesDescription)"
  }
}
