//
//  AOC6.swift
//  AOC2018
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC6: Puzzle {

    var threshold = 10000
    
    let chars = "abcdefghijklmnopqrstuvwxyzACDEFGHIJKLMNOPQRSTUVWXYZ"
    
    let data: [String]
    var points: [Point]
    let grid: ExpandableGrid<Point?>
    let grid2: ExpandableGrid<Int>
    
    init(inputFile: String) {
        
        let reader = InputReader(input: inputFile)
        data = reader.toStringArray()
        
        points = []
        grid = ExpandableGrid<Point?>(width: 1, height: 1, initialValue: nil)
        grid2 = ExpandableGrid<Int>(width: 1, height: 1, initialValue: 0)
        
        // 1, 1
        let regex = Regex("^(\\d+), (\\d+)$")
        data.forEach { (line) in
            let groups = regex.match(in: line)
            if groups.count == 3 {
                points.append(Point(x: Int(groups[1])!, y: Int(groups[2])!))
            } else {
                print("Bad input: \(line)")
            }
        }
        
        for p in points {
            grid.setValueAt(x: p.x, y: p.y, value: p)
            grid2.setValueAt(x: p.x, y: p.y, value: 0)
        }
    }

    func run1() -> String {
        calculateClosest()
//        printGrid()
        return String(getLargestArea())
    }
    
    func run2() -> String {
       calculateDistanceToAll()
        let size = closestRegionSize()
        print("Closest region size is \(size)")
        return String(size)
    }
    
    func closestRegionSize() -> Int {
        var count = 0
        for x in grid2.minX...grid2.maxX {
            for y in grid2.minY...grid2.maxY {
                if grid2.valueAt(x: x, y: y) < threshold {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func calculateDistanceToAll() {
        for x in grid2.minX...grid2.maxX {
            for y in grid2.minY...grid2.maxY {
                grid2.setValueAt(x: x, y: y, value: distanceToAll(x: x, y: y))
            }
        }
    }
    
    func distanceToAll(x: Int, y: Int) -> Int {
        var d = 0
        let point = Point(x: x, y: y)
        for p in points {
            d += p.distanceTo(point: point)
        }
        
        return d
    }
    
    func calculateClosest() {
        // First, fill out the grid
        for x in grid.minX...grid.maxX {
            for y in grid.minY...grid.maxY {
                setClosest(x: x, y: y)
            }
        }
        
        // Now expand the grid out until it stabilises
        while !isGridStable() {
            growGrid()
        }
    }

    func getLargestArea() -> Int {
        let areas = calculateAreas()
        var largestArea: Int = 0
        var largestPoint: Point?
        for (point, area) in areas {
            if !isInfiniteRegionForPoint(point) {
                if area > largestArea {
                    largestArea = area
                    largestPoint = point
                }
            }
        }
        print("Largest area is \(largestArea) for (\(largestPoint!.x), \(largestPoint!.y))")
        return largestArea
    }
    
    func setClosest(x: Int, y: Int) {
        grid.setValueAt(x: x, y: y, value: closestPoint(x: x, y: y))
    }
    
    func closestPoint(x: Int, y: Int) -> Point? {
        let point = Point(x: x, y: y)
        var closest: Point?
        var distance: Int = grid.width + grid.height + 1 // Can't be further away than that!
        for p in points {
            let d = point.distanceTo(point: p)
            if d == distance {
                // More than one at this distance
                closest = nil
            }
            if d < distance {
                distance = d
                closest = p
            }
        }
        return closest
    }
    
    func growGrid() {
        grid.expand(direction: .up)
        for x in grid.minX...grid.maxX {
            setClosest(x: x, y: grid.minY)
        }
        grid.expand(direction: .down)
        for x in grid.minX...grid.maxX {
            setClosest(x: x, y: grid.maxY)
        }
        grid.expand(direction: .left)
        for y in grid.minY...grid.maxY {
            setClosest(x: grid.minX, y: y)
        }
        grid.expand(direction: .right)
        for y in grid.minY...grid.maxY {
            setClosest(x: grid.maxX, y: y)
        }
    }
    
    func isGridStable() -> Bool {
        var stable = true
        
        // If the perimeter has the same values as the rectangle immediately inside it, then the pattern has stabilised
        // Ignore the corners
        for x in (grid.minX + 1)...(grid.maxX - 1) {
            stable = (grid.valueAt(x: x, y: grid.minY) == grid.valueAt(x: x, y: grid.minY + 1)) && (grid.valueAt(x: x, y: grid.maxY) == grid.valueAt(x: x, y: grid.maxY - 1))
            if !stable {
                break
            }
        }
        
        if stable {
            for y in (grid.minY + 1)...(grid.maxY - 1) {
                stable = (grid.valueAt(x: grid.minX, y: y) == grid.valueAt(x: grid.minX + 1, y: y)) && (grid.valueAt(x: grid.maxX, y: y) == grid.valueAt(x: grid.maxX - 1, y: y))
                if !stable {
                    break
                }
            }
        }

        return stable
    }
    
    func isInfiniteRegionForPoint(_ point: Point) -> Bool {
        // If a point on the perimeter has this as the closest, then the region is infinite
        var infinite = false
        
        // Ignore the corners
        for x in (grid.minX + 1)...(grid.maxX - 1) {
            infinite = (grid.valueAt(x: x, y: grid.minY) == point) || (grid.valueAt(x: x, y: grid.maxY) == point)
            if infinite {
                break
            }
        }
        
        if !infinite {
            for y in (grid.minY + 1)...(grid.maxY - 1) {
                infinite = (grid.valueAt(x: grid.minX, y: y) == point) || (grid.valueAt(x: grid.maxX, y: y) == point)
                if infinite {
                    break
                }
            }
        }
        
//        let c = charForPoint(point)
//        let s = infinite ? "" : "not "
//        print("\(c) is \(s)infinite")
    
        return infinite
    }
    
    func calculateAreas() -> [Point : Int] {
        var areas: [Point : Int] = [:]
        
        for x in grid.minX...grid.maxX {
            for y in grid.minY...grid.maxY {
                if let p = grid.valueAt(x: x, y: y) {
                    if areas[p] == nil {
                        areas[p] = 0
                    }
                    areas[p] = areas[p]! + 1
                }
            }
        }
        
        return areas
    }
    
    func printGrid() {
            for y in (grid.minY...grid.maxY) {
                var line = ""
                for x in grid.minX...grid.maxX {
                    if let p = grid.valueAt(x: x, y: y) {
                        var c = charForPoint(p)
                        if points.firstIndex(of: Point(x: x, y: y)) != nil {
                            c = "*"
                        }
                        line += c
                    } else {
                    line += "."
                }
            }
            print(line)
        }
    }
    
    func charForPoint(_ p: Point) -> String {
        let n: Int = points.firstIndex(of: p) ?? 0
        let c = String(chars[String.Index(encodedOffset: n)])
        return c
    }
}
