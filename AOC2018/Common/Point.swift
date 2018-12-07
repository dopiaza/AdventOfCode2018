//
//  Point.swift
//  AOC2018
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class Point {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func distanceTo(point: Point) -> Int {
        return abs(point.x - x) + abs(point.y - y)
    }
}
