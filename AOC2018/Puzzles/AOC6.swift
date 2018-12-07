//
//  AOC6.swift
//  AOC2018
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC6: Puzzle {

    let data: [String]
    var points: [Point]
    
    init() {
        
        let reader = InputReader(input: "6-example")
        data = reader.toStringArray()
        
        points = []
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
    }

    func run1() {
        
    }
    
    func run2() {
        
    }
    
}



