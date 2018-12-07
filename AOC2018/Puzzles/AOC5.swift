//
//  AOC5.swift
//  AOC2018
//
//  Created by David Wilkinson on 06/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC5: Puzzle {
    
    let data: String
    
    init() {
        
        let reader = InputReader(input: "5")
        data = reader.toString()
    }
    
    func run1() {
        let polymer = runReactor(polymer: data)
        print("Final polymer length \(polymer.count)")
    }
    
    func run2() {
        var shortest: Int?
        
        let alphabet = "abcdefghijklmnopqrstuvwxyz"
        // Sanity check
        if alphabet.count != 26 {
            fatalError("Oops")
        }
        
        for c in alphabet {
            let reacted = fullyReact(polymer: data, removing: c)
            let length = reacted.count
            if shortest == nil || length < shortest! {
                shortest = length
            }
        }
        
        print("Shortest: \(shortest!)")
    }

    func runReactor(polymer: String) -> String {
        var p = polymer
        var lastPolymer = ""
    
        while p.count != lastPolymer.count {
            lastPolymer = p
            p = react(polymer: p)
        }
        return p
    }
    
    func react(polymer: String) -> String {
        var newPolymer: [Character] = []
        
        for c in polymer {
            if newPolymer.last == toggleCase(c) {
                newPolymer.remove(at: newPolymer.count - 1)
            } else {
                newPolymer.append(c)
            }
        }
        return String(newPolymer)
    }
    
    func fullyReact(polymer: String, removing unit: Character) -> String {
        let altUnit = toggleCase(unit)
        return react(polymer: polymer.replacingOccurrences(of: String(unit), with: "").replacingOccurrences(of: String(altUnit), with: ""))
    }
    
    func toggleCase(_ c: Character) -> Character {
        let s = String(c)
        if s.lowercased() == s {
            return s.uppercased().first!
        }
        return s.lowercased().first!
    }
}
