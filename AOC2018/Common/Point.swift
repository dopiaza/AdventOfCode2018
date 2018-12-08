//
//  Point.swift
//  AOC2018
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class Point: Equatable, Hashable {
    var x: Int
    var y: Int
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func distanceTo(point: Point) -> Int {
        return abs(point.x - x) + abs(point.y - y)
    }
}
