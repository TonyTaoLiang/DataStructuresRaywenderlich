//
//  Vertex.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/25.
//

import Foundation

public class Vertex<T> {

    public let index: Int
    public let data: T
    //方便遍历 是否已经查看过
    public var visited: Bool

    public init(index index: Int, data data: T) {
        self.index = index
        self.data = data
        visited = false
    }
}


//extension Vertex: Equatable where T: Equatable {}

extension Vertex:Hashable{

// Important: `hashValue` is deprecated as a `Hashable` requirement. To
    ///   conform to `Hashable`, implement the `hash(into:)` requirement instead.
    
    //    public var hashValue: Int {
    //        return index.hashValue
    //      }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }

    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.index == rhs.index
    }

}

extension Vertex: CustomStringConvertible {

  public var description: String {
    return "\(index): \(data)"
  }
}
