//
//  RingBuffer.swift
//  DataStructuresRaywenderlich
//
//  Created by Tonytaoliang on 2021/2/16.
//

import Foundation
//RingBuffer就是一个Fix-Size array
struct RingBuffer<T> {

    private var array: [T?]
    private var readIndex = 0//head
    private var writeIndex = 0//tail

    public init(count: Int) {
        array = Array(repeating: nil, count: count)
    }

    public var first : T? {
        array[readIndex % array.count]
    }

    private var availableSpaceForReading: Int {
        //有多少数据可以读
        writeIndex - readIndex

    }

    public var isEmpty: Bool {
        //2个index相遇则空了
        availableSpaceForReading == 0

    }

    private var availableSpaceForWriting: Int {
        //数组的长度减能够读的（即入列了的个数则为还能入列多少个）
        array.count - availableSpaceForReading
    }

    public var isFull: Bool{

        availableSpaceForWriting == 0
    }

    public mutating func write(_ element: T) -> Bool{

        if !isFull {

            array[writeIndex % array.count] = element
            writeIndex += 1

            return true
        }else{

            return false
        }
    }

    public mutating func read() -> T?{

        if !isEmpty {

            let element = array[readIndex % array.count]
            readIndex += 1
            return element
        }else{

            return nil
        }
    }
}

extension RingBuffer: CustomStringConvertible {
  public var description: String {
    let values = (0..<availableSpaceForReading).map {
      String(describing: array[($0 + readIndex) % array.count]!)
    }
    return "[" + values.joined(separator: ", ") + "]"
  }
}
