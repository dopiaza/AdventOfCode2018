//
//  AOC14.swift
//  AOC2018
//
//  Created by David Wilkinson on 14/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC14: Puzzle {
    let input: Int
    var scoreboard: [Int] = [3, 7]
    var elves: [Int] = [0, 1]
    
    init(input: Int) {
        self.input = Int(input)
    }
    
    func run1() -> String {
        
        practice(num: input)
        return getScores(after: input)
    }
    
    func run2() -> String {
        return String(makeRecipesLookingFor(String(input)))
    }
    
    func practice(num: Int) {
        while scoreboard.count < num + 10 {
            makeRecipes()
        }
    }
    
    func getScores(after: Int) -> String {
        var scores: String = ""
        for i in after..<(after + 10) {
            scores += String(scoreboard[i])
        }
        return scores
    }
    
    func find(_ sequence: String) -> Int {
        var counter = 0
        practice(num: 1000)
        var position: Int? = positionOf(sequence)
        
        while position == nil {
            counter += 1000
            print(counter)
            practice(num: counter)
            position = positionOf(sequence, startingAt: counter - sequence.count)
        }
        
        return position!
    }
    
    func positionOf(_ sequence: String, startingAt: Int? = nil) -> Int? {
        var position: Int?
        let numbers: [Int] = sequence.map { Int(String($0))! }
        let start = startingAt ?? 0
        for i in start..<(scoreboard.count - numbers.count) {
            var found = true
            for j in 0..<numbers.count {
                if scoreboard[i + j] != numbers[j] {
                    found = false
                    break
                }
            }
            if found {
                position = i
                break
            }
        }
        return position
    }
    
    func makeRecipes() {
        var score = 0
        for elf in elves {
            score += scoreboard[elf]
        }
        
        for c in String(score) {
            scoreboard.append(Int(String(c))!)
        }
        
        for elf in 0..<elves.count {
            elves[elf] = (elves[elf] + 1 + scoreboard[elves[elf]]) % scoreboard.count
        }
    }
    
    func makeRecipesLookingFor(_ sequence: String) -> Int {
        var position: Int?
        let numbers: [Int] = sequence.map { Int(String($0))! }
        let numbersCount = numbers.count
        
        while position == nil {
            var score = 0
            for elf in elves {
                score += scoreboard[elf]
            }
            
            for c in String(score) {
                scoreboard.append(Int(String(c))!)
                let count = scoreboard.count
                if count >= numbersCount {
                    let last = scoreboard[(count - numbersCount)...]
                    if last.elementsEqual(numbers) {
                        position = count - numbersCount
                    }
                }
            }
            
            for elf in 0..<elves.count {
                elves[elf] = (elves[elf] + 1 + scoreboard[elves[elf]]) % scoreboard.count
            }
        }
        
        return position!
    }
}
