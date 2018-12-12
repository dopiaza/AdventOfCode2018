//
//  AOC11.swift
//  AOC2018
//
//  Created by David Wilkinson on 11/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC11: Puzzle {
    let dimension = 300
    let serialNumber: Int
    var cells: [[Int]]
    let summedAreaTable: SummedAreaTable
    
    init(serialNumber: Int) {
        self.serialNumber = serialNumber
        cells = Array(repeating: Array(repeating: 0, count: dimension + 1), count: dimension + 1)
        summedAreaTable = SummedAreaTable(table: cells)
    }

    func run1() -> String {
        calculateCells()
        let (x, y) = maxCoordinate
        return "\(x),\(y)"
    }
    
    func run2() -> String {
        calculateCells()
        let square = maxSquare
//        let square = maxSquareUsingSummedAreaTable
        return "\(square.x),\(square.y),\(square.d)"
    }
    
    func calculateCells() {
        for x in 1...dimension {
            for y in 1...dimension {
                cells[x][y] = powerForCell(x: x, y: y)
            }
        }
    }
    
    var maxCoordinate: (Int, Int) {
        get {
            var coordinate: (Int, Int)?
            var power: Int = 0
            
            for x in 1...(dimension - 2) {
                for y in 1...(dimension - 2) {
                    let p = powerForSquare(x: x, y: y)
                    if coordinate == nil || p > power {
                        power = p
                        coordinate = (x, y)
                    }
                }
            }
            
            return coordinate!
        }
    }
        
    var maxSquare: Square {
        get {
            var squareCache: [Square : Int] = [:]
            var maxSquare: Square?
            var maxPower = 0
            
            for d in 1...dimension {
                for x in 1...(dimension - d + 1) {
                    for y in 1...(dimension - d + 1) {
                        var power: Int
                        // We can calculate the power by using previously calculated smaller squares
                        // Add up smaller squares, remove the overlapped area and add in the missed corner squares
                        // power = power(x, y, d-1) + power(x+1, y+1, d-1) - power(x+1, y+1, d-2) + power(x + d - 1, y, 1) + power(x, y + d -1, 1)
                        if d == 1 {
                            power =  cells[x][y]
                            squareCache[Square(x: x, y: y, d: 1 )] = power
                        } else {
                            power = squareCache[Square(x: x, y: y, d: d - 1)]!
                                + squareCache[Square(x: x + 1, y: y + 1, d: d - 1)]!
                                - (squareCache[Square(x: x + 1, y: y + 1, d: d - 2)] ?? 0) //  No overlap on 2x2 square
                                + squareCache[Square(x: x + d - 1, y: y, d: 1)]!
                                + squareCache[Square(x: x, y: y + d - 1, d: 1)]!
                        }
                        let square = Square(x: x, y: y, d: d)
                        squareCache[square] = power
                        if maxSquare == nil || power > maxPower {
                            maxSquare = square
                            maxPower = power
                        }
                    }
                }
            }
            return maxSquare!
        }
    }
    
    var maxSquareUsingSummedAreaTable: Square {
        get {
            var maxSquare: Square?
            var maxPower: Int = 0
            for d in 1...dimension {
                for x in 1...(dimension - d + 1) {
                    for y in 1...(dimension - d + 1) {
                        let power = summedAreaTable.sumForRectangle(minX: x, minY: y, maxX: x + d - 1, maxY: y + d - 1)
                        if maxSquare == nil || power > maxPower {
                            let square = Square(x: x, y: y, d: d)
                            maxSquare = square
                            maxPower = power
                        }
                    }
                }
            }
            return maxSquare!
        }
    }
    
    func powerForSquare(x: Int, y : Int, d: Int = 3) -> Int {
        var power: Int = 0
        for sx in x..<(x + d) {
            for sy in y..<(y + d) {
                let p = cells[sx][sy]
                power += p
            }
        }
        return power
    }
    
    func powerForCell(x: Int, y: Int) -> Int {
        let rackId = x + 10
        var powerLevel = rackId * y
        powerLevel += serialNumber
        powerLevel *= rackId
        powerLevel = (powerLevel/100) % 10
        powerLevel -= 5
        return powerLevel

    }
}

class Square: Hashable {
    
    var x: Int
    var y: Int
    var d: Int
    
    init(x: Int, y: Int, d: Int) {
        self.x = x
        self.y = y
        self.d = d
    }
    
    static func == (lhs: Square, rhs: Square) -> Bool {
        return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.d == rhs.d)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(d)
    }
}
