//
//  AOC7.swift
//  AOC2018
//
//  Created by David Wilkinson on 08/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC7: Puzzle {
    
    let data: [String]
    var steps: [String : SleighStep] = [:]
    var workers = 5
    var stepTime = 60
    var workerStates: [SleighStep?] = []
    let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    init(inputFile: String) {
        
        let reader = InputReader(input: inputFile)
        data = reader.toStringArray()
        
        data.forEach { (s) in
            // Step C must be finished before step A can begin.
            let regex = Regex("^Step (\\w) must be finished before step (\\w) can begin.$")
            let groups = regex.match(in: s)
            if groups.count == 3 {
                let id1 = groups[1]
                let id2 = groups[2]
                
                var step1 = steps[id1]
                if step1 == nil {
                    step1 = SleighStep(id: id1)
                    steps[id1] = step1
                }
                
                var step2 = steps[id2]
                if step2 == nil {
                    step2 = SleighStep(id: id2)
                    steps[id2] = step2
                }
                
                step2!.addPrerequisite(step: step1!)
                
            } else {
                print("Bad input: \(s)")
            }
        }
    }
    
    func run1() -> String {
        let stepList = runSteps()
        return stepList
    }
    
    func run2() -> String {
        let time = buildIt()
        return String(time)
    }

    func runSteps() -> String {
        var stepList: String = ""
        var nextStep = findNextStep()
        
        while nextStep != nil {
            stepList.append(nextStep!.id)
            completeStep(step: nextStep!)
            nextStep = findNextStep()
        }
        
        return stepList
    }
    
    func buildIt() -> Int {
        var second = -1
        
        for _ in 0..<workers {
            workerStates.append(nil)
        }
        
        while !steps.isEmpty || !areAllWorkersIdle() {
            second += 1
            var status = String(second) + ": "
            
            // Decrement timer for existing steps
            for i in 0..<workers {
                if let w = workerStates[i] {
                    w.timeToComplete -= 1
                    if w.timeToComplete == 0 {
                        completeStep(step: w)
                        workerStates[i] = nil
                    }
                }
            }
            
            // Allocate new steps
            for i in 0..<workers {
                if workerStates[i] == nil {
                    workerStates[i] = findNextStep()
                }
                status += (workerStates[i]?.id ?? ".")
            }
            
//            print(status)
        }
        
        return second
    }
    
    func completeStep(step: SleighStep) {
        for (_, s) in steps {
            s.removePrerequisite(step: step)
        }
        steps.removeValue(forKey: step.id)
    }
    
    func findNextStep() -> SleighStep? {
        var nextStep: SleighStep?
    
        for (id, step) in steps {
            if step.prerequisites.count == 0 && !step.allocated {
                if nextStep ==  nil {
                    nextStep = step
                } else {
                    if id < nextStep!.id {
                        nextStep = step
                    }
                }
            }
        }
        
        if nextStep != nil {
            nextStep!.timeToComplete = stepTime + alphabet.distance(from: alphabet.startIndex, to: alphabet.firstIndex(of: nextStep!.id.first!)!) + 1
            nextStep?.allocated = true
        }
        
        return nextStep
    }
    
    func areAllWorkersIdle() -> Bool {
        var idle = true
        for step in workerStates {
            if step != nil {
                idle = false
                break
            }
        }
        return idle
    }
}

class SleighStep: Equatable {
    
    let id: String
    var prerequisites: [SleighStep] = []
    var timeToComplete: Int
    var allocated: Bool = false
    
    static func == (lhs: SleighStep, rhs: SleighStep) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String, timeToComplete: Int = 0) {
        self.id = id
        self.timeToComplete = timeToComplete
    }
    
    func addPrerequisite(step: SleighStep) {
        prerequisites.append(step)
    }
    
    func removePrerequisite(step: SleighStep) {
        prerequisites.removeAll { (s) -> Bool in
            return s.id == step.id
        }
    }
}
