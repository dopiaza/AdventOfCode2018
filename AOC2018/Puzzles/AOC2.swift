//
//  AOC2.swift
//  AOC2018
//
//  Created by David Wilkinson on 05/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC2: Puzzle {
    let data: [String]
    let inputFile: String
    
    init(inputFile: String) {
        let reader = InputReader(input: inputFile)
        self.inputFile = inputFile
        data = reader.toStringArray()
    }
    
    func run1() -> String {
        var twoCount: Int = 0
        var threeCount: Int = 0
        
        data.forEach { (s) in
            if hasRepeats(id: s, count: 2) {
                twoCount += 1
            }
            if hasRepeats(id: s, count: 3) {
                threeCount += 1
            }
        }
        
        let checksum = twoCount * threeCount
        print ("Checksum: \(checksum)")
        return String(checksum)
    }
    
    func run2() -> String {
        let length = data[0].count
        var answer: String = "?"
        
        for i in 0..<length {
            let matches = self.matches(differingPosition: i)
            if !matches.isEmpty {
                print("\(i): \(matches)")
                answer = matches.first?.key ?? "?"
            }
        }
        
        return answer
    }
    
    func hasRepeats(id: String, count: Int) -> Bool {
        let allLetters = Array(id)
        var letters = Set<Character>()
        
        allLetters.forEach { (c) in
            letters.insert(c)
        }
        
        for c in letters {
            let letterCount = allLetters.filter { $0 == c }.count
            if letterCount == count {
                return true
            }
        }
        
        return false
    }
    
    func matches(differingPosition: Int) -> [String: [String]] {
        let reduced = data.reduce(into: [String: [String]]()) { (matches, id) in
            var s = id
            s.remove(at: String.Index(encodedOffset: differingPosition))
            matches[s, default: []].append(id)
        }
        
        let duplicates = reduced.filter { $1.count > 1 }
        
        return duplicates
    }
}
