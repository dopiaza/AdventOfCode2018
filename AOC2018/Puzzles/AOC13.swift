//
//  AOC13.swift
//  AOC2018
//
//  Created by David Wilkinson on 13/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC13: Puzzle {
    
    let track: Track
    
    init(inputFile: String) {
        let reader = InputReader(input: inputFile)
        let data = reader.toStringArray()
        
        track = Track(width: 1, height: 1, initialValue: nil)
        
        var x = 0
        var y = 0
        
        data.forEach { (line) in
            x = 0
            for c in line {
                var connections: TrackSection.Connection?
                switch c {
                case " ":
                    break
                case "|":
                    connections = TrackSection.Connection([.up, .down])
                case "-":
                    connections = TrackSection.Connection([.left, .right])
                case "/":
                    if track.valueAt(x: x, y: y - 1)?.connections.contains(.down) ?? false {
                        connections = TrackSection.Connection([.up, .left])
                    } else {
                        connections = TrackSection.Connection([.down, .right])
                    }
                case "\\":
                    if track.valueAt(x: x, y: y - 1)?.connections.contains(.down) ?? false {
                        connections = TrackSection.Connection([.up, .right])
                    } else {
                        connections = TrackSection.Connection([.down, .left])
                    }
                case "+":
                    connections = TrackSection.Connection([.up, .right, .down, .left])
                case "^":
                    track.carts.append(Cart(track: track, location: Point(x: x, y: y), direction: .up))
                    connections = TrackSection.Connection([.up, .down])
                case ">":
                    track.carts.append(Cart(track: track, location: Point(x: x, y: y), direction: .right))
                    connections = TrackSection.Connection([.left, .right])
                case "v":
                    track.carts.append(Cart(track: track, location: Point(x: x, y: y), direction: .down))
                    connections = TrackSection.Connection([.up, .down])
                case "<":
                    track.carts.append(Cart(track: track, location: Point(x: x, y: y), direction: .left))
                    connections = TrackSection.Connection([.left, .right])
                default:
                    fatalError("Bad input")
                }
                if connections != nil {
                    track.setValueAt(x: x, y: y, value: TrackSection(connections: connections!))
                } else {
                    track.setValueAt(x: x, y: y, value: nil)
                }
                x += 1
            }
            y += 1
        }
    }
    
    func run1() -> String {
        var answer = "?"
        var count = 0
        do {
            while true {
                print(count)
                try track.tick()
                count += 1
            }
        } catch TrackError.crash(let (p, _, _)) {
            answer = "\(p.x),\(p.y)"
        } catch {
            fatalError("WTF")
        }
        return answer
    }
    
    func run2() -> String {
        var answer = "?"
        var count = 0
        do {
            while true {
//                print(count)
//                track.dump()
                try track.tick(remove: true)
                count += 1
            }
        }
        catch TrackError.lastCartStanding(let cart)
        {
            answer = "\(cart.location.x),\(cart.location.y)"
        } catch {
            fatalError("WTF")
        }
        
        return answer
    }
    
}

class Track: ExpandableGrid<TrackSection?> {
    var carts: [Cart] = []
    var cartLocations: [Point : Cart] = [:]
    
    func cartAtPoint(x: Int, y: Int) -> Cart? {
        return cartAtPoint(point: Point(x: x, y: y))
    }
    
    func cartAtPoint(point: Point) -> Cart? {
        return cartLocations[point]
    }

    func tick(remove: Bool = false) throws {
        for cart in carts {
            cart.hasMoved = false
        }
        
        for y in minY...maxY {
            for x in minX...maxX {
                if let cart = cartAtPoint(x: x, y: y) {
                    if !cart.hasMoved {
                        let oldPoint = Point(x: x, y: y)
                        var nextPoint: Point?
                        let nextDirection = cart.nextDirection()
                        switch nextDirection {
                        case .up:
                            nextPoint = Point(x: x, y: y - 1)
                        case .right:
                            nextPoint = Point(x: x + 1, y: y)
                        case .down:
                            nextPoint = Point(x: x, y: y + 1)
                        case .left:
                            nextPoint = Point(x: x - 1, y: y)
                        }
                        if let obstacle = cartAtPoint(point: nextPoint!) {
                            if remove {
                                carts = carts.filter { $0 !== cart && $0 !== obstacle }
                                cartLocations.removeValue(forKey: nextPoint!)
                                cartLocations.removeValue(forKey: oldPoint)
                                print("Carts left: \(carts.count)")

                            } else {
                                throw TrackError.crash(point: nextPoint!, cart1: cart, cart2: obstacle)
                            }
                        } else {
                            cart.location = nextPoint!
                            cart.direction = nextDirection
                            cartLocations.removeValue(forKey: oldPoint)
                            cartLocations[nextPoint!] = cart
                            cart.hasMoved = true
                        }
                    }
                }
            }
        }
        
        if carts.count == 1 {
            throw TrackError.lastCartStanding(cart: carts.first!)
        }
    }
    
    func dump() {
        for y in minY...maxY {
            var line = ""
            for x in minX...maxX {
                var s = valueAt(x: x, y: y)?.toString() ?? " "
                if let car = cartAtPoint(x: x, y: y) {
                    s = car.toString()
                }
                line += s
            }
            print(line)
        }
    }
    
    func dumpFile(name: String) {
        if let dir = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent("AOC/" + name)
            var text: String = ""
            for y in minY...maxY {
                var line = ""
                for x in minX...maxX {
                    var s = valueAt(x: x, y: y)?.toString() ?? " "
                    if let car = cartAtPoint(x: x, y: y) {
                        s = car.toString()
                    }
                    line += s
                }
                text += line + "\n"
            }
            
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
                fatalError("Cannot write file")
            }
        }
    }
}


class TrackSection {
    struct Connection: OptionSet {
        let rawValue: Int
        
        static let up       = Connection(rawValue: 1 << 0)
        static let right    = Connection(rawValue: 1 << 1)
        static let down     = Connection(rawValue: 1 << 2)
        static let left     = Connection(rawValue: 1 << 3)
    }
    
    let connections: Connection
    
    init(connections: Connection) {
        self.connections = connections
    }
    
    func hasConnection(connection: Connection) -> Bool {
        return connections.contains(connection)
    }
    
    func isCross() -> Bool {
        return connections.contains(.up) && connections.contains(.right) && connections.contains(.down) && connections.contains(.left)
    }
    
    func findExit(entrance: Direction) -> Direction {
        if entrance != .up && connections.contains(.up) {
            return .up
        }
        if entrance != .right && connections.contains(.right) {
            return .right
        }
        if entrance != .down && connections.contains(.down) {
            return .down
        }
        if entrance != .left && connections.contains(.left) {
            return .left
        }
        fatalError("Nowhere to go")
    }
    
    func toString() -> String {
        var s: String?
        if connections == [.up, .down, .left, .right] {
            s = "+"
        }
        if connections == [.up, .down] {
            s = "|"
        }
        if connections == [.left, .right] {
            s = "-"
        }
        if connections == [.up, .left] {
            s = "/"
        }
        if connections == [.up, .right] {
            s = "\\"
        }
        if connections == [.down, .left] {
            s = "\\"
        }
        if connections == [.down, .right] {
            s = "/"
        }

        return s!
    }
}

enum Direction: Int {
    case up = 0, right, down, left
}

class Cart {
    enum Turn: Int {
        case left = 0, straight, right
    }
    
    let track: Track
    var direction: Direction
    var location: Point
    var lastTurn = Turn.right
    var hasMoved = false
    
    init(track: Track, location: Point, direction: Direction) {
        self.track = track
        self.location = location
        self.direction = direction
        track.cartLocations[location] = self
    }
    
    func nextTurn() -> Turn {
        let turn = Turn(rawValue: (lastTurn.rawValue + 1) % 3)!
        lastTurn = turn
        return turn
    }
    
    func peekAheadForNextTurn() -> Turn {
        let turn = Turn(rawValue: (lastTurn.rawValue + 1) % 3)!
        return turn
    }
    
    func nextDirection() -> Direction {
        var nextDirection: Direction?
        if let section = track.valueAt(x: location.x, y: location.y) {
            if section.isCross() {
                let next = nextTurn()
                nextDirection = Direction(rawValue: (4 + (direction.rawValue + next.rawValue - 1)) % 4)
                if nextDirection == nil {
                    fatalError("Nowhere to go")
                }
            } else {
                let entrance = Direction(rawValue: (direction.rawValue + 2) % 4)
                nextDirection = Direction(rawValue: section.findExit(entrance: entrance!).rawValue)
                if nextDirection == nil {
                    fatalError("Nowhere to go")
                }
            }
        } else {
            fatalError("No track below car!")
        }
        
        return nextDirection!
    }
    
    func toString() -> String {
        switch direction {
        case .up:
            return "^"
        case .right:
            return ">"
        case .down:
            return "v"
        case .left:
            return "<"
        }
    }
}

enum TrackError: Error {
    case crash(point: Point, cart1: Cart, cart2: Cart)
    case lastCartStanding(cart: Cart)
}
