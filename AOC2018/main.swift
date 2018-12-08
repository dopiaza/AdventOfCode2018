//
//  main.swift
//  AOC2018
//
//  Created by David Wilkinson on 05/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

let start = Date()

if CommandLine.arguments.count != 4 {
    print("Please specify the day number to run, the stage of the puzzle and the input file")
    exit(1)
}

let day: Int = Int(CommandLine.arguments[1]) ?? 0
let stage: Int = Int(CommandLine.arguments[2]) ?? 0
let input: String = CommandLine.arguments[3]

print("Day \(day), stage \(stage), input \(input)")

var puzzle: Puzzle!

switch day {
case 1:
    puzzle = AOC1(inputFile: input)
case 2:
    puzzle = AOC2(inputFile: input)
case 3:
    puzzle = AOC3(inputFile: input)
case 4:
    puzzle = AOC4(inputFile: input)
case 5:
    puzzle = AOC5(inputFile: input)
case 6:
    puzzle = AOC6(inputFile: input)
case 7:
    puzzle = AOC7(inputFile: input)
case 8:
    puzzle = AOC8(inputFile: input)
default:
    print("Cannot load puzzle for Day \(day)")
    exit(1)
}

var answer = "???"

switch stage {
case 1:
    answer = puzzle.run1()
case 2:
    answer = puzzle.run2()
default:
    print("Cannot find Stage \(stage) for Day \(day)")
    exit(1)
}

let end = Date()

let interval = end.timeIntervalSince(start)

print("Answer: \(answer)")
print("Took \(interval) seconds")
