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
    
    init(width: Int, height: Int, initialValue: T) {
        self.initialValue = initialValue
        grid = []
        for x in 0..<width {
            grid.append([])
            for _ in 0..<height {
                grid[x].append(initialValue)
            }
        }
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
    
    func valueAt(x: Int, y: Int) -> T {
        return grid[x][y]
    }
    
    func setValueAtt(x: Int, y: Int, value: T) {
        grid[x][y] = value
    }
    
    func expand(direction: Direction, distance: Int = 1) {
        for _ in 0..<distance {
            switch direction {
            case .up:
                for x in 0..<grid.count {
                    grid[x].insert(initialValue, at: 0)
                }
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
            }
        }
    }
}

