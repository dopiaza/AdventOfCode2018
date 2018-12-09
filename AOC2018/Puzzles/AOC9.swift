//
//  AOC9.swift
//  AOC2018
//
//  Created by David Wilkinson on 09/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC9: Puzzle {
    
    var lastMarble: Int = 0
    var numPlayers: Int = 0
    
    var players: [Player] = []
    
    init(inputFile: String) {
        let reader = InputReader(input: inputFile)
        let s = reader.toString()
        let regex = Regex("^(\\d+) players; last marble is worth (\\d+) points$")
        let groups = regex.match(in: s)
        if groups.count == 3 {
            numPlayers = Int(groups[1])!
            lastMarble = Int(groups[2])!
        } else {
            print("Bad input: \(s)")
        }
        
        for _ in 0..<numPlayers {
            players.append(Player())
        }
    }

    func run1() -> String {
        play()
        var winner: Player?
        
        for p in players {
            if winner == nil || p.score > winner!.score {
                winner = p
            }
        }
        
        return String(winner!.score)
    }
    
    func run2() -> String {
        lastMarble *= 100
        play()
        var winner: Player?
        
        for p in players {
            if winner == nil || p.score > winner!.score {
                winner = p
            }
        }
        
        return String(winner!.score)
    }
    
    func play() {
        var currentPlayer = -1
        let circle = MarbleCircle(marble: Marble(value: 0))
        
        for i in 1...lastMarble {
            currentPlayer = (currentPlayer + 1) % numPlayers
            let player = players[currentPlayer]
            player.score += circle.place(marble: Marble(value: i))
        }
    }
}

class Marble: Equatable {
    var value: Int
    var next: Marble?
    var previous: Marble?
    
    static func == (lhs: Marble, rhs: Marble) -> Bool {
        return lhs.value == rhs.value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    func forward(_ count: Int) -> Marble? {
        var marble: Marble? = self
        for _ in 0..<count {
            marble = marble?.next
        }
        
        return marble
    }
    
    func back(_ count: Int) -> Marble? {
        var marble: Marble? = self
        for _ in 0..<count {
            marble = marble?.previous
        }
        
        return marble
    }
}

class Player {
    var score: Int = 0
}

class MarbleCircle {
    var currentMarble: Marble
    
    init(marble: Marble) {
        marble.next = marble
        marble.previous = marble
        currentMarble = marble
    }
    
    func place(marble: Marble) -> Int {
        var score = 0
        
        if marble.value > 0 && marble.value % 23 == 0 {
            let remove = currentMarble.back(7)
            score += marble.value + remove!.value
            currentMarble = remove!.next!
            remove!.previous!.next = remove!.next!
            remove!.next!.previous = remove!.previous!
        } else {
            let  m = currentMarble.next!
            marble.previous = m
            marble.next = m.next!
            m.next!.previous = marble
            m.next = marble
            currentMarble = marble
        }
        
//        dump()
//        dumpr()
        return score
    }
    
    func dump() {
        var s = String(currentMarble.value)
        var m = currentMarble.next!
        
        while m != currentMarble {
            s += " " + String(m.value)
            m = m.next!
        }
        print(s)
    }

    func dumpr() {
        var s = String(currentMarble.value)
        var m = currentMarble.previous!
        
        while m != currentMarble {
            s += " " + String(m.value)
            m = m.previous!
        }
        print(s)
    }
}
