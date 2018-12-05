//
//  AOC1.swift
//  AOC2018
//
//  Created by David Wilkinson on 05/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC1: Puzzle {
    func run1() {
        let reader = InputReader(input: "1")
        let data = reader.toStringArray()
        print ("\(data.count) lines read")
        
        let frequency = calibrate(start: 0, changes: data)
        
        print("Final frequency: \(frequency)")
    }
    
    func run2() {
        let reader = InputReader(input: "1")
        let data = reader.toStringArray()
        print ("\(data.count) lines read")
        
        let frequency = findDuplicate(start: 0, changes: data)
        
        print("Duplicate frequency: \(frequency)")
    }
    
    func calibrate(start: Int, changes: [String]) -> Int {
        var frequency = start
        changes.forEach { (s) in
            if let change = Int(s) {
                frequency += change
            } else {
                print("\(s) is not an Int")
            }
        }
        return frequency
    }
    
    func findDuplicate(start: Int, changes: [String]) -> Int {
        var frequency = start
        var frequencies = Set<Int>()
        
        frequencies.insert(start)
        
        repeater: while true {
            for i in 0..<changes.count {
                let s = changes[i]
                if let change = Int(s) {
                    frequency += change
                    if frequencies.contains(frequency) {
                        break repeater
                    }
                    frequencies.insert(frequency)
                } else {
                    print("\(s) is not an Int")
                }
            }
        }
        
        return frequency
    }
}
