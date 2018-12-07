//
//  InputReader.swift
//  AOC2018
//
//  Created by David Wilkinson on 05/12/2018.
//  Copyright © 2018 dopiaza.org. All rights reserved.
//

import Foundation

class InputReader {
    let inputFile: String
    
    init(input: String) {
        inputFile = "Input/\(input).txt"
    }
    
    func toStringArray(trimBlank: Bool = true) -> [String] {
        do {
            let text = try String(contentsOfFile: inputFile, encoding: String.Encoding.utf8)
            var lines = text.components(separatedBy: CharacterSet.newlines)
            if trimBlank {
                lines = lines.filter { $0 != "" }
            }
            return lines
        } catch {
            fatalError("Cannot load file \(inputFile)")
        }
    }
    
    func toString() -> String {
        return toStringArray().first!
    }
}
