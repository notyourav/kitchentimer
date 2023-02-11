//
//  KTimer.swift
//  KitchenTimer
//
//  Created by Theo on 4/5/22.
//

import SwiftUI

var timers: Array<KTimer> = Array<KTimer>()

struct KTimer : Identifiable, Equatable {
    public var timeBegin: Date
    public var timeEnd: Date
    public var idx: Int

    public var name: String = "New Timer"
    
    public var elapsedTime: TimeInterval { get { return Date.now.timeIntervalSince(timeBegin) }}
    public var length: TimeInterval { get { return timeEnd.timeIntervalSince(timeBegin) }}
    public var timeRemaining: TimeInterval { get { return timeEnd.timeIntervalSinceNow }}
    public var finished: Bool { get { elapsedTime > length }}

//    public var countingDown = false
    
    init(begin: Date, end: Date, index: Int, name: String) {
        timeBegin = begin
        timeEnd = end
        idx = index
        self.name = name
    }
    init(_ length: Int, index: Int, name: String) {
        let d = Date.now
        self.init(begin: d, end: d + Double(length), index: index, name: name)
    }
//    init(_ length: Double, index: Int, name: String, countingDown: Bool) {
//        self.init(length, index: index, name: name)
//        self.countingDown = countingDown
//    }

    public var id: Int {
        return idx
    }
}
