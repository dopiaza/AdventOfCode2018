//
//  ExpandableGrid_Tests.swift
//  AOC2018 Tests
//
//  Created by David Wilkinson on 08/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import XCTest

class ExpandableGrid_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreate() {
        let grid = ExpandableGrid<Int>(width: 10, height: 20, initialValue: 42)
        XCTAssertEqual(grid.width, 10)
        XCTAssertEqual(grid.height, 20)
        XCTAssertEqual(grid.valueAt(x: 6, y: 12), 42)
    }
    
    func testValues() {
        let grid = ExpandableGrid<Int>(width: 5, height: 5, initialValue: 0)
        grid.setValueAt(x: 2, y: 2, value: 5)
        XCTAssertEqual(grid.valueAt(x: 2, y: 2), 5)
        grid.setValueAt(x: 20, y: 20, value: 8)
        XCTAssertEqual(grid.valueAt(x: 20, y: 20), 8)
        
        XCTAssertEqual(grid.valueAt(x: 50, y: 50), 0)
    }
    
    func testExpand() {
        let grid = ExpandableGrid<Int>(width: 5, height: 5, initialValue: 0)
        grid.setValueAt(x: 2, y: 2, value: 5)
        grid.expand(direction: .right, distance: 5)
        XCTAssertEqual(grid.width, 10)
        XCTAssertEqual(grid.height, 5)
        XCTAssertEqual(grid.valueAt(x: 2, y: 2), 5)
        grid.expand(direction: .down, distance: 5)
        XCTAssertEqual(grid.width, 10)
        XCTAssertEqual(grid.height, 10)
        XCTAssertEqual(grid.valueAt(x: 2, y: 2), 5)
        grid.expand(direction: .left, distance: 5)
        XCTAssertEqual(grid.width, 15)
        XCTAssertEqual(grid.height, 10)
        XCTAssertEqual(grid.valueAt(x: 2, y: 2), 5)
        grid.expand(direction: .up, distance: 5)
        XCTAssertEqual(grid.width, 15)
        XCTAssertEqual(grid.height, 15)
        XCTAssertEqual(grid.valueAt(x: 2, y: 2), 5)
    }
    
    func testDistance() {
        let p1 = Point(x: 5, y: 5)
        let p2 = Point(x: -10, y: 12)
        XCTAssertEqual(p1.distanceTo(point: p2), 22)
    }
    
    func testMinMax() {
        let grid = ExpandableGrid<Int>(width: 5, height: 5, initialValue: 0)
        grid.expand(direction: .left, distance: 5)
        grid.expand(direction: .up, distance: 5)
        XCTAssertEqual(grid.minX, -5)
        XCTAssertEqual(grid.maxX, 4)
        XCTAssertEqual(grid.minY, -5)
        XCTAssertEqual(grid.maxY, 4)
    }
}
