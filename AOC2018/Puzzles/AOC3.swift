//
//  AOC3.swift
//  AOC2018
//
//  Created by David Wilkinson on 06/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC3: Puzzle {
    let data: [String]
    
    init() {
        let reader = InputReader(input: "3")
        data = reader.toStringArray()
    }
    
    func run1() {
        let claims = getClaims()
        let fabric = Fabric()
        
        claims.forEach { (claim) in
            fabric.addClaim(claim)
        }
        
        print("Multiple claims for: \(fabric.multipleClaims)")
    }
    
    func run2() {
        let claims = getClaims()
        let fabric = Fabric()
        
        claims.forEach { (claim) in
            fabric.addClaim(claim)
        }
        
        claims.forEach { (claim) in
            if !fabric.hasOverlap(claim: claim) {
                print("Claim \(claim.id) has no overlap")

            }
        }
        
    }
    
    func getClaims() -> [Claim] {
        var claims:[Claim] = []
        
        data.forEach { (s) in
            if let c = Claim(from: s) {
                claims.append(c)
            } else {
                print("Invalid claim: \(s)")
            }
        }
        return claims
    }
    
    
}

class Claim {
    let id: Int
    let left: Int
    let top: Int
    let width: Int
    let height: Int
    
    init?(from: String) {
        // #1 @ 1,3: 4x4
        let pattern = "^#(\\d+)\\s+@\\s+(\\d+),(\\d+):\\s+(\\d+)x(\\d+)$"
        let regex = Regex(pattern)
        let groups = regex.match(in: from)
        if groups.count == 6 {
            id = Int(groups[1])!
            left = Int(groups[2])!
            top = Int(groups[3])!
            width = Int(groups[4])!
            height = Int(groups[5])!
        } else {
            return nil
        }
    }
   
}

class Fabric {
    var fabric: [[Int]] = []
    var noOverlap: Claim?

    func addClaim(_ claim: Claim) {
        for x in claim.left..<(claim.width + claim.left) {
            for y in claim.top..<(claim.height + claim.top) {
                useAt(x: x, y: y)
            }
        }
    }
    
    func hasOverlap(claim: Claim) -> Bool {
        var overlap = false
        out: for x in claim.left..<(claim.width + claim.left) {
            for y in claim.top..<(claim.height + claim.top) {
                if fabric[x][y] > 1 {
                    overlap = true
                    break out
                }
            }
        }
        return overlap
    }
    
    func useAt(x: Int, y: Int) {
        if x > fabric.count - 1 {
            for _ in fabric.count...x {
                fabric.append([])
            }
        }
        
        if y > fabric[x].count - 1 {
            for _ in fabric[x].count...y {
                fabric[x].append(0)
            }
        }
        
        fabric[x][y] += 1
    }
    
    var multipleClaims: Int {
        get {
            var n = 0
            for row in fabric {
                for col in row {
                    if col > 1 {
                        n += 1
                    }
                }
            }
            return n
        }
    }
}
