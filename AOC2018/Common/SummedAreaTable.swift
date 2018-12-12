//
//  SummedAreaTable.swift
//  AOC2018
//
//  Created by David Wilkinson on 11/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

// https://en.wikipedia.org/wiki/Summed-area_table
// https://www.geeksforgeeks.org/summed-area-table-submatrix-summation/

import Foundation

class SummedAreaTable {
    fileprivate var table: [[Int]]
    fileprivate var summedAreaTable: [[Int]]
    
    init(table: [[Int]]) {
        self.table = table
        self.summedAreaTable = Array(repeating: Array(repeating: 0, count: table[0].count), count: table.count)
        calculateSums()
    }
    
    func sumForRectangle(minX: Int, minY: Int, maxX: Int, maxY: Int) -> Int {
        return summedAreaTable[maxX][maxY]
            - summedAreaTable[minX][maxY]
            - summedAreaTable[maxX][minY]
            + summedAreaTable[minX][minY]
    }
    
    fileprivate func calculateSums() {
        sumRectangleFor(x: table.count - 1, y: table[0].count - 1)
    }
    
    fileprivate func sumRectangleFor(x: Int, y: Int) {
        if x == 0 && y == 0 {
            summedAreaTable[x][y] = 0
            return
        }
        
        // Start with the previous rectangle
        sumRectangleFor(x: x - 1, y: y - 1)
        var sum: Int = summedAreaTable[x - 1][y - 1]
        // And add the row below and the column to the right
        for i in 0...x {
            sum += table[i][y]
        }
        
        for i in 0..<y {
            sum += table[x][i]
        }
        
        summedAreaTable[x][y] = sum
    }
}

