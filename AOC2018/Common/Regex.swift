//
//  Regex.swift
//  AOC2018
//
//  Created by David Wilkinson on 06/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class Regex {
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
    }
    
    func match(in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(text.startIndex..., in: text)
            var groups = [String]()

            if let result = regex.firstMatch(in: text, options: [], range: range) {
                for i in  0 ..< result.numberOfRanges {
                    let group = String(text[Range(result.range(at: i), in: text)!])
                    groups.append(group)
                }
            }
            
            return groups
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
