//
//  Graph.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/6/25.
//

import Foundation

public enum EdgeType {
    case directed
    case undirected
}

public protocol Graph {

    associatedtype Element

    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>,
                         to destination: Vertex<Element>,
                         weight: Double?)
    //这个方法可以复用上面的，所以写在延展中，这样遵守graph协议的类只需要实现addDirectedEdge就可以同时拥有这2个方法
//    func addUndirectedEdge(between source: Vertex<Element>,
//                           and destination: Vertex<Element>,
//                           weight: Double?)
    func add(_ edge: EdgeType, from source: Vertex<Element>,
             to destination: Vertex<Element>,
             weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>,
                to destination: Vertex<Element>) -> Double?

}

extension Graph {

  public func addUndirectedEdge(between source: Vertex<Element>,
                                and destination: Vertex<Element>,
                                weight: Double?) {
    addDirectedEdge(from: source, to: destination, weight: weight)
    addDirectedEdge(from: destination, to: source, weight: weight)
  }


    //广度优先
  public func breadthFirstSearch(from source: Vertex<Element>)
          -> [Vertex<Element>] {

    //queue keeps track of the neighboring vertices to visit next.

    //enqueued remembers which vertices have been enqueued before so you don't enqueue the same vertex twice.It is a Set to ensure fast O(1) lookup

    //visited is an array that stores the order in which the vertices were explored.

    var queue = QueueStack<Vertex<Element>>()
    var enqueued = Set<Vertex<Element>>()
    var visited: [Vertex<Element>] = []

    queue.enqueue(source)
    enqueued.insert(source)

    //如果队列里还有
    while let vertex = queue.dequeue() {

        visited.append(vertex)

        //下层入列
        edges(from: vertex).forEach { edge in

            //如果不在enqueued中说明还没有入列 就入列
            if !enqueued.contains(edge.destination) {

                queue.enqueue(edge.destination)
                enqueued.insert(edge.destination)

            }

        }

    }

    return visited
  }

    //深度优先，王铮用递归，这里用栈（递归本质其实就是压栈）
    /*
     stack is used to store your path through the graph.

     pushed remembers which vertices have been pushed before so you don't visit the same vertex twice. It is a Set to ensure fast O(1) lookup.

     visited is an array that stores the order in which the vertices were visited.

     1.You continue to check the top of the stack for a vertex until the stack is empty. You have labeled this loop outer so you have a way to continue to the next vertex, even within nested loops.

     2.You find all the neighboring edges for the current vertex.

     3.If there are no edges, you pop the vertex off the stack and continue to the next one.

     4.Here you loop through every edge connected to the current vertex and check to see if the neighboring vertex has been seen. If not, you push it onto the stack and add it to the visited array. It may seem a bit premature to mark this vertex as visited (you haven't peeked at it yet), but since vertices are visited in the order in which they are added to the stack, it results in the correct order.

     5.Now that you've found a neighbor to visit, you continue the outer loop and move to the newly pushed neighbor.

     6.If the current vertex did not have any unvisited neighbors, you know you've reached a dead end and can pop it off the stack.
     */
    func depthFirstSearch(from source: Vertex<Element>)
          -> [Vertex<Element>] {

        var stack: Stack<Vertex<Element>> = []
        var pushed: Set<Vertex<Element>> = []
        var visited: [Vertex<Element>] = []

        stack.push(source)
        pushed.insert(source)
        visited.append(source)

        //这里使用了标签循环，很巧妙，这样就可以跳出内层循环去外层循环，不用把内层循环的边全部入栈

        outer: while let vertex = stack.peek(){ //1栈不为空

            let neighbors = edges(from: vertex)//2
            //如果此顶点没边了 表示到底了 推出他
            guard !neighbors.isEmpty else {//3
                stack.pop()
                continue
            }

            for edge in neighbors {//4

                if !pushed.contains(edge.destination) {

                    stack.push(edge.destination)
                    pushed.insert(edge.destination)
                    visited.append(edge.destination)

                    //这里很关键 循环一次就直接跳出去外层
                    continue outer//5
                }

            }

            //如果此顶点有边 且所有的边都已经加过了 就进了死胡同 那么 开始回溯
            stack.pop()//6
        }

        return visited
      }

    //MARK: - 递归版本
    //https://github.com/raywenderlich/swift-algorithm-club/tree/master/Depth-First%20Search
    func depthFirstSearchRecursion(from source: Vertex<Element>) -> [Vertex<Element>] {

        
      var nodesExplored : [Vertex<Element>] = [source]

    //Vertex改成了Class。如果是Struct参数需要加inout，然后后面for edge in edges(from: source) 这个传入的又不是inout类型就很麻烦
      source.visited = true

      for edge in edges(from: source) {

        if !edge.destination.visited {

//            let temp = depthFirstSearch(from: edge.destination)
//            nodesExplored.append(contentsOf: temp)
            //数组nodesExplored里面不能是source.data 必须是这个source 不然报错No exact matches in call to instance method '* * *' 好像是swift必须知道真实的类型 不能是泛型

            nodesExplored.append(contentsOf: depthFirstSearchRecursion(from: edge.destination))


        }
      }
      return nodesExplored
    }
}


//MARK: - 王铮的递归
/*

 boolean found = false; // 全局变量或者类成员变量

 public void dfs(int s, int t) {
   found = false;
   boolean[] visited = new boolean[v];
   int[] prev = new int[v];
   for (int i = 0; i < v; ++i) {
     prev[i] = -1;
   }
   recurDfs(s, t, visited, prev);
   print(prev, s, t);
 }

 private void recurDfs(int w, int t, boolean[] visited, int[] prev) {
   if (found == true) return;
   visited[w] = true;
   if (w == t) {
     found = true;
     return;
   }
   for (int i = 0; i < adj[w].size(); ++i) {
     int q = adj[w].get(i);
     if (!visited[q]) {
       prev[q] = w;
       recurDfs(q, t, visited, prev);
     }
   }
 }
 **/

