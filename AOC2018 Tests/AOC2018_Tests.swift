//
//  AOC2018_Tests.swift
//  AOC2018 Tests
//
//  Created by David Wilkinson on 07/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import XCTest

class AOC2018_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1() {
        let puzzle = AOC1(inputFile: "1-example")
        XCTAssertEqual(puzzle.run1(), "3")
        XCTAssertEqual(puzzle.run2(), "2")
    }
    
    func test2() {
        let puzzleA = AOC2(inputFile: "2a-example")
        XCTAssertEqual(puzzleA.run1(), "12")
        let puzzleB = AOC2(inputFile: "2b-example")
        XCTAssertEqual(puzzleB.run2(), "fgij")
    }

    func test3() {
        let puzzle = AOC3(inputFile: "3-example")
        XCTAssertEqual(puzzle.run1(), "4")
        XCTAssertEqual(puzzle.run2(), "3")
    }

    func test4() {
        let puzzle = AOC4(inputFile: "4-example")
        XCTAssertEqual(puzzle.run1(), "240")
        XCTAssertEqual(puzzle.run2(), "4455")
    }
    
    func test5() {
        let puzzle = AOC5(inputFile: "5-example")
        XCTAssertEqual(puzzle.run1(), "10")
        XCTAssertEqual(puzzle.run2(), "4")
    }

    func test6() {
        let puzzle = AOC6(inputFile: "6-example")
        puzzle.threshold = 32
        XCTAssertEqual(puzzle.run1(), "17")
        XCTAssertEqual(puzzle.run2(), "16")
    }
    
    func test7() {
        var puzzle = AOC7(inputFile: "7-example")
        puzzle.workers = 2
        puzzle.stepTime = 0
        XCTAssertEqual(puzzle.run1(), "CABDFE")
        
        puzzle = AOC7(inputFile: "7-example")
        puzzle.workers = 2
        puzzle.stepTime = 0
        XCTAssertEqual(puzzle.run2(), "15")
    }
    
    func test8() {
        let puzzle = AOC8(inputFile: "8-example")
        XCTAssertEqual(puzzle.run1(), "138")
        XCTAssertEqual(puzzle.run2(), "66")
    }

    func test9() {
        var puzzle = AOC9(inputFile: "9a-example")
        XCTAssertEqual(puzzle.run1(), "32")
        puzzle = AOC9(inputFile: "9b-example")
        XCTAssertEqual(puzzle.run1(), "8317")
        puzzle = AOC9(inputFile: "9c-example")
        XCTAssertEqual(puzzle.run1(), "146373")
        puzzle = AOC9(inputFile: "9d-example")
        XCTAssertEqual(puzzle.run1(), "2764")
        puzzle = AOC9(inputFile: "9e-example")
        XCTAssertEqual(puzzle.run1(), "54718")
        puzzle = AOC9(inputFile: "9f-example")
        XCTAssertEqual(puzzle.run1(), "37305")
    }
    
    func test11() {
        var puzzle = AOC11(serialNumber: 8)
        XCTAssertEqual(puzzle.powerForCell(x: 3, y: 5), 4)
        puzzle = AOC11(serialNumber: 57)
        XCTAssertEqual(puzzle.powerForCell(x: 122, y: 79), -5)
        puzzle = AOC11(serialNumber: 39)
        XCTAssertEqual(puzzle.powerForCell(x: 217, y: 196), 0)
        puzzle = AOC11(serialNumber: 71)
        XCTAssertEqual(puzzle.powerForCell(x: 101, y: 153), 4)

        puzzle = AOC11(serialNumber: 18)
        puzzle.calculateCells()
        XCTAssertEqual(puzzle.powerForSquare(x: 33, y: 45), 29)
        XCTAssertEqual(puzzle.run1(), "33,45")
        XCTAssertEqual(puzzle.run2(), "90,269,16")
        puzzle = AOC11(serialNumber: 42)
        puzzle.calculateCells()
        XCTAssertEqual(puzzle.powerForSquare(x: 21, y: 61), 30)
        XCTAssertEqual(puzzle.run1(), "21,61")
        XCTAssertEqual(puzzle.run2(), "232,251,12")
    }
    
    func test12() {
        let puzzle = AOC12(inputFile: "12-example")
        XCTAssertEqual(puzzle.run1(), "325")
    }

    func test13() {
        var puzzle = AOC13(inputFile: "13a-example")
        XCTAssertEqual(puzzle.run1(), "7,3")
        puzzle = AOC13(inputFile: "13b-example")
        XCTAssertEqual(puzzle.run2(), "6,4")
    }
}
