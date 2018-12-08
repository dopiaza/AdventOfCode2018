//
//  AOC8.swift
//  AOC2018
//
//  Created by David Wilkinson on 08/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class AOC8: Puzzle {
    
    var tokens: [Int]
    var root: Node?
    
    init(inputFile: String) {
        let reader = InputReader(input: inputFile)
        let s = reader.toString()
        let data = s.split(separator: " ")
        tokens = data.map { Int($0)! }
    }
    
    func generateTree() {
        if root == nil {
            root = extractNode(tokens: &tokens)
        }
    }
    
    func extractNode(tokens: inout [Int]) -> Node {
        let node = Node()
        let childCount = nextToken(tokens: &tokens)
        let metadataCount = nextToken(tokens: &tokens)
        
        for _ in 0..<childCount {
            node.children.append(extractNode(tokens: &tokens))
        }
        
        for _ in 0..<metadataCount {
            node.metadata.append(nextToken(tokens: &tokens))
        }
        
        return node
    }
    
    func nextToken(tokens: inout [Int]) -> Int {
        return tokens.remove(at: 0)
    }
    
    func run1() -> String {
        generateTree()
        let sum = sumMetadata(node: root!)
        return String(sum)
    }
    
    func run2() -> String {
        generateTree()
        let v = value(node: root!)
        return String(v)
    }
    
    func sumMetadata(node: Node) -> Int {
        var sum: Int = 0
        
        for n in node.metadata {
            sum += n
        }
        
        for c in node.children {
            sum += sumMetadata(node: c)
        }
        
        return sum
    }
    
    func value(node: Node) -> Int {
        var v: Int = 0
        
        if node.children.isEmpty {
            for n in node.metadata {
                v += n
            }
        } else {
            for n in node.metadata {
                if n != 0 && n <= node.children.count {
                    v += value(node: node.children[n - 1])
                }
            }
        }
        
        return v
    }
}

class Node {
    var children: [Node] = []
    var metadata: [Int] = []
}
