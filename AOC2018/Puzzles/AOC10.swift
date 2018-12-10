//
//  AOC10.swift
//  AOC2018
//
//  Created by David Wilkinson on 10/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC10: Puzzle {
    
    let data: [String]
    var lights: [Light] = []
    
    init(inputFile: String) {
        
        let reader = InputReader(input: inputFile)
        data = reader.toStringArray()
        
        // position=< 9,  1> velocity=< 0,  2>
        let regex = Regex("^position=<\\s*(.+),\\s*(.+)> velocity=<\\s*(.+),\\s*(.+)>$")
        data.forEach { (s) in
            let groups = regex.match(in: s)
            if groups.count == 5 {
                let p = Point(x: Int(groups[1])!, y: Int(groups[2])!)
                let v = Velocity(xSpeed: Int(groups[3])!, ySpeed: Int(groups[4])!)
                let light = Light(point: p, velocity: v)
                lights.append(light)
            } else {
                print("Bad input: \(s)")
            }
        }
    }
    
    func run1() -> String {
        let (sky, _) = coalesce()
        print(sky)
        return ""
    }
    
    func run2() -> String {
        let (sky, seconds) = coalesce()
        print(sky)
        return String(seconds)
    }
    
    func coalesce() -> (String, Int) {
        // Wait until the lights cluster together - their bounding rectangle should (hopefully) be at a minimum at this point
        var lastArea: Int?
        var currentArea = area
        var seconds: Int = 0
        
        while lastArea == nil || currentArea < lastArea! {
            lastArea = currentArea
            for light in lights {
                light.move()
            }
            currentArea = area
            seconds += 1
        }
        
        // We've now gone too far as they've started to expand again - move backe one step
        for light in lights {
            light.moveBack()
        }
        seconds -= 1
        
        return (sky, seconds)
    }
    
    var minX: Int {
        get {
            var min: Int?
            for light in lights {
                if min == nil || light.position.x < min! {
                    min = light.position.x
                }
            }
            return min!
        }
    }
    
    var maxX: Int {
        get {
            var max: Int?
            for light in lights {
                if max == nil || light.position.x > max! {
                    max = light.position.x
                }
            }
            return max!
        }
    }
    
    var minY: Int {
        get {
            var min: Int?
            for light in lights {
                if min == nil || light.position.y < min! {
                    min = light.position.y
                }
            }
            return min!
        }
    }
    
    var maxY: Int {
        get {
            var max: Int?
            for light in lights {
                if max == nil || light.position.y > max! {
                    max = light.position.y
                }
            }
            return max!
        }
    }
    
    var area: Int {
        get {
            return abs((maxX - minX) * (maxY - minY))
        }
    }
    
    var sky: String {
        get {
            let grid = ExpandableGrid<Character>(width: 1, height: 1, initialValue: " ")
            for light in lights {
                grid.setValueAt(x: light.position.x, y: light.position.y, value: "*")
            }
            var s = ""
            for y in minY...maxY {
                var line = ""
                for x in minX...maxX {
                    line += String(grid.valueAt(x: x, y: y))
                }
                s += line + "\n"
            }
            return s
        }
    }
}


struct Light {
    var position: Point
    var velocity: Velocity

    init(point: Point, velocity: Velocity) {
        self.position = point
        self.velocity = velocity
    }
    
    func move() {
        position.x += velocity.xSpeed
        position.y += velocity.ySpeed
    }

    func moveBack() {
        position.x -= velocity.xSpeed
        position.y -= velocity.ySpeed
    }
}

struct Velocity {
    var xSpeed: Int
    var ySpeed: Int
    
    init(xSpeed: Int, ySpeed: Int) {
        self.xSpeed = xSpeed
        self.ySpeed = ySpeed
    }
}
