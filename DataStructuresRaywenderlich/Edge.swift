//
//  Edge.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/27.
//

import Foundation

public struct Edge<T>{

    public let source: Vertex<T>
    
    public var destination: Vertex<T>

    public let weight: Double?


}

//扩展使泛型遵守Equable协议 Prim最小生成树类有用
extension Edge: Equatable where T: Equatable {}
