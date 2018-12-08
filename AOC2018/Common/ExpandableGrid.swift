//
//  ExpandableGrid.swift
//  AOC2018
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class ExpandableGrid<T> {
    enum Direction {
        case up, right, down, left
    }
    
    var grid: [[T]]
    var initialValue: T
    var origin: Point
    
    init(width: Int, height: Int, initialValue: T) {
        self.initialValue = initialValue
        grid = []
        for x in 0..<max(width, 1) {
            grid.append([])
            for _ in 0..<max(height, 1) {
                grid[x].append(initialValue)
            }
        }
        origin = Point(x: 0, y: 0)
    }
    
    var width: Int {
        get {
            return grid.count
        }
    }
    
    var height: Int {
        get {
            return grid[0].count
        }
    }
    
    var minX: Int {
        get {
            return -origin.x
        }
    }
    
    var maxX: Int {
        get {
            return grid.count - origin.x - 1
        }
    }
    
    var minY: Int {
        get {
            return -origin.y
        }
    }
    
    var maxY: Int {
        get {
            return grid[0].count - origin.y - 1
        }
    }
    
    func valueAt(x: Int, y: Int) -> T {
        adjustGridFor(x: x, y: y)
        return grid[x + origin.x][y + origin.y]
    }
    
    func setValueAt(x: Int, y: Int, value: T) {
        adjustGridFor(x: x, y: y)
        grid[x + origin.x][y + origin.y] = value
    }
    
    fileprivate func adjustGridFor(x: Int, y: Int) {
        let gridx = x + origin.x
        let gridy = y + origin.y
        if gridx > width - 1 {
            expand(direction: .right, distance: gridx - width + 1)
        }
        if gridy > height - 1 {
            expand(direction: .down, distance: gridy - height + 1)
        }
        if gridx < 0 {
            expand(direction: .left, distance: -gridx)
        }
        if gridy < 0 {
            expand(direction: .up, distance: -gridy)
        }
    }
    
    func expand(direction: Direction, distance: Int = 1) {
        for _ in 0..<distance {
            switch direction {
            case .up:
                for x in 0..<grid.count {
                    grid[x].insert(initialValue, at: 0)
                }
                origin.y += 1
            case .right:
                grid.append([])
                for _ in 0..<grid[0].count {
                    grid[grid.count - 1].append(initialValue)
                }
            case .down:
                for x in 0..<grid.count {
                    grid[x].append(initialValue)
                }
            case .left:
                grid.insert([], at: 0)
                for _ in 0..<grid[1].count {
                    grid[0].append(initialValue)
                }
                origin.x += 1
            }
        }
    }
}

