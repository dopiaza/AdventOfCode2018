//
//  AOC4.swift
//  AOC2018
//
//  Created by David Wilkinson on 06/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC4: Puzzle {
    let data: [String]
    let sortedData: [String]
    
    init() {
        
        let reader = InputReader(input: "4")
        data = reader.toStringArray()
        
        sortedData = data.sorted { (a, b) -> Bool in
            if let da = AOC4.extractTimestamp(s: a) {
                if let db = AOC4.extractTimestamp(s: b) {
                    return da < db
                }
            }
            return false
        }
    }
    
    func run1() {
        let guards = processData()
        var sleepiestGuard: Guard?
        var sleepyTime: Int = 0
        
        guards.forEach { (id, g) in
            let t = g.sleepyTime
            if t > sleepyTime {
                sleepiestGuard = g
                sleepyTime = t
            }
        }
        
        print("Sleepiest guard is #\(sleepiestGuard!.id) with \(sleepyTime) minutes")
        
        let sleepyMinutes = sleepiestGuard?.sleepByMinute
        var sleepiestMinute = -1
        var sleepiestSleep = 0
        
        sleepyMinutes?.forEach({ (minute, sleep) in
            if sleep > sleepiestSleep {
                sleepiestSleep = sleep
                sleepiestMinute = minute
            }
        })
        
        print("Sleepiest minute was \(sleepiestMinute) with \(sleepiestSleep) snoozes")
        print("Answer: \(sleepiestGuard!.id * sleepiestMinute)")
    }
    
    func run2() {
        let guards = processData()
        var sleepiestMinute = -1
        var sleepiestSleep = 0
        var sleepiestGuard: Guard?
        
        for i in 0..<60 {
            guards.forEach { (id, g) in
                let sleep = g.sleepForMinute(i)
                if sleep > sleepiestSleep {
                    sleepiestSleep = sleep
                    sleepiestMinute = i
                    sleepiestGuard = g
                }
            }
        }
        
        print("Sleepiest guard was #\(sleepiestGuard!.id) with \(sleepiestSleep) sleeps at minute \(sleepiestMinute)")
        print("Answer: \(sleepiestGuard!.id * sleepiestMinute)")
}
    
    func processData() -> [Int : Guard] {
        // [1518-11-05 00:03] Guard #99 begins shift
        // [1518-11-05 00:45] falls asleep
        // [1518-11-05 00:55] wakes up

        let beginRegex = Regex("Guard #(\\d+) begins shift")
        let sleepRegex = Regex("falls asleep")
        let wakeRegex  = Regex("wakes up")
        
        var guards: [Int : Guard] = [:]
        var currentGuard: Guard?
        var currentShift: Shift?
        var startedSleep: Int?

        sortedData.forEach { (s) in
            let groups = beginRegex.match(in: s)
            if groups.count == 2 {
                if currentShift != nil {
                    if startedSleep != nil {
                        currentShift?.snooze(from: startedSleep!, to: 60)
                    }
                    currentGuard?.addShift(currentShift!)
//                    print(currentShift!.description)
                    currentShift = nil
                }
                
                let id = Int(groups[1])!
                if let theGuard = guards[id] {
                    currentGuard = theGuard
                } else {
                    let theGuard = Guard(id: id)
                    guards[id] = theGuard
                    currentGuard = theGuard
                }
                currentShift = Shift()
                startedSleep = nil
            }
            
            let minute = AOC4.extractMinute(s: s)

            if sleepRegex.match(in: s).count > 0 {
                startedSleep = minute
            }
            
            if wakeRegex.match(in: s).count > 0 {
                currentShift!.snooze(from: startedSleep ?? 0, to: minute!)
                startedSleep = nil
            }
        }
        
        if currentShift != nil {
            if startedSleep != nil {
                currentShift?.snooze(from: startedSleep!, to: 60)
            }
            currentGuard?.addShift(currentShift!)
//            print(currentShift!.description)
        }
        
        return guards
    }
    
    static func extractTimestamp(s: String) -> Date? {
        var timestamp: Date?
        // [1518-11-01 00:00] Guard #10 begins shift
        let pattern = "^\\[(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2})\\]"
        let regex = Regex(pattern)
        let groups = regex.match(in: s)
        if groups.count == 6 {
            var dateComponents = DateComponents()
            dateComponents.year = Int(groups[1])
            dateComponents.month = Int(groups[2])
            dateComponents.day = Int(groups[3])
            dateComponents.timeZone = TimeZone(abbreviation: "UTC")
            dateComponents.hour = Int(groups[4])
            dateComponents.minute = Int(groups[5])
            
            let userCalendar = Calendar.current
            timestamp = userCalendar.date(from: dateComponents)
        }
        return timestamp
    }
    
    static func extractMinute(s: String) -> Int? {
        var minute: Int?
        // [1518-11-01 00:00] Guard #10 begins shift
        let pattern = "^\\[(\\d{4})-(\\d{2})-(\\d{2}) (\\d{2}):(\\d{2})\\]"
        let regex = Regex(pattern)
        let groups = regex.match(in: s)
        if groups.count == 6 {
            minute = Int(groups[5])
        }
        return minute
    }
}


class Guard {
    let id: Int
    var shifts: [Shift] = []
    
    init(id: Int) {
        self.id = id
    }
    
    func addShift(_ shift: Shift) {
        shifts.append(shift)
    }
    
    var sleepyTime: Int {
        get {
            var asleep = 0
            shifts.forEach { (shift) in
                asleep += shift.sleepyTime
            }
            return asleep
        }
    }
    
    var sleepByMinute: [Int : Int] {
        var sleep: [Int : Int] = [:]
        for i in 0..<60 {
            sleep[i] = sleepForMinute(i)
        }
        return sleep
    }
    
    func sleepForMinute(_ minute: Int) -> Int {
        var total = 0
        shifts.forEach { (shift) in
            total += (shift.states[minute] == .asleep) ? 1 : 0
        }
        return total
    }
}

class Shift {
    enum State {
    case awake, asleep
    }
    
    var states: [Int : State] = [:]
    
    init() {
        for i in 0..<60 {
            states[i] = .awake
        }
    }
    
    func snooze(from: Int, to: Int) {
        for i in from..<to {
            states[i] = .asleep
        }
    }
    
    var sleepyTime: Int {
        return states.filter { $0.value == .asleep }.count
    }
    
    public var description: String {
        var s: [String] = []
        for i in 0..<60 {
            s.append(states[i] == .asleep ? "#" : ".")
        }
        return s.joined()
    }
}
