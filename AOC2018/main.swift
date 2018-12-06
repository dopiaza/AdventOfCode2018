//
//  main.swift
//  AOC2018
//
//  Created by David Wilkinson on 05/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

let start = Date()

if CommandLine.arguments.count != 3 {
    print("Please specify the day number to run, and the stage of the puzzle")
    exit(1)
}

let day: Int = Int(CommandLine.arguments[1]) ?? 0
let stage: Int = Int(CommandLine.arguments[2]) ?? 0

print("Day \(day), stage \(stage)")

var puzzle: Puzzle!

switch day {
case 1:
    puzzle = AOC1()
case 2:
    puzzle = AOC2()
case 3:
    puzzle = AOC3()
case 4:
    puzzle = AOC4()
default:
    print("Cannot load puzzle for Day \(day)")
    exit(1)
}

switch stage {
case 1:
    puzzle.run1()
case 2:
    puzzle.run2()
default:
    print("Cannot find Stage \(stage) for Day \(day)")
    exit(1)
}

let end = Date()

let interval = end.timeIntervalSince(start)

print("\(interval) seconds")
