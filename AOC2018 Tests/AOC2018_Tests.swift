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
}
