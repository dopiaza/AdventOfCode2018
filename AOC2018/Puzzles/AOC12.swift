//
//  AOC12.swift
//  AOC2018
//
//  Created by David Wilkinson on 12/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC12: Puzzle {
    
    var data: [String]
    var plants: String
    var rules: [String : Character] = [:]
    var generations = 20
    var origin = 0

    init(inputFile: String) {
        
        let reader = InputReader(input: inputFile)
        data = reader.toStringArray()
        
        let s = data[0]
        // initial state: #..#.#..##......###...###
        let initialRegex = Regex("^initial state: ([#\\.]+)$")
        let initialGroups = initialRegex.match(in: s)
        if initialGroups.count == 2 {
            plants =  initialGroups[1]
        } else {
            fatalError("Bad input: \(s)")
        }
        
        
        data.remove(at: 0)
        
        //...## => #
        let regex = Regex("^([#\\.]{5}) => ([#\\.])$")
        for rule in data {
            let groups = regex.match(in: rule)
            if groups.count == 3 {
                let s = groups[1]
                let c = groups[2]
                rules[s] = Character(c)
            } else {
                fatalError("Bad input: \(rule)")
            }
        }
    }
    
    func run1() -> String {
        evolve()
        return String(potTotal)
    }
    
    func run2() -> String {
        generations = 50000000000
        evolve()
        return String(potTotal)
    }
    
    func evolve() {
        
        for i in 0..<generations {
            // Grow in each direction so we can apply rules to the full set
            let paddedPlants = "...." + plants + "...."
            var newPlants = ""
            let oldOrigin = origin
            for i in 0..<(paddedPlants.count - 5) {
                let start = String.Index(encodedOffset: i)
                let end = String.Index(encodedOffset: i + 5)
                let s = String(paddedPlants[start..<end])
                var c = "."
                if let result = rules[s] {
                    c = String(result)
                }
                newPlants += c
            }
            origin += 2
            
            // Trim excess empty pots from start and end
            while newPlants.hasPrefix(".") {
                newPlants.remove(at: String.Index(encodedOffset: 0))
                origin -= 1
            }
            while newPlants.hasSuffix(".") {
                newPlants.remove(at: newPlants.lastIndex(of: ".")!)
            }

            if plants == newPlants {
                print("Repeating at \(i)")
                let originShift = origin - oldOrigin
                let generationsLeft = generations - i - 1
                origin += generationsLeft * originShift
                break
            }

            plants = newPlants
            
            print("\(i): \(plants)")
        }
    }

    
    var potTotal: Int {
        get {
            var i = 0
            var total = 0
            for c in plants {
                if c == "#" {
                    let potValue = i - origin
                    total += potValue
                }
                i += 1
            }
            return total
        }
    }
}

