//
//  parser.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/19.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

class Parser {
    
    let fileManager = FileManager.default
    
    let A_COMMAND_PATTERN = "@([0-9a-zA-Z_\\.\\$:]+)"
    let C_COMMAND_PATTERN = "(?:(A?M?D?)=)?([^;]+)(?:;(.+))?"
    let L_COMMAND_PATTERN = "\\(([0-9a-zA-Z_\\.\\$:]*)\\)"
    
    let FILE_PATH_PATTERN = "([0-9a-zA-Z]+)\\.asm$"
    
    var instruction: String!
    var result: String = ""
    
    init(_ path: String) {
        
        guard path.isMatch(pattern: FILE_PATH_PATTERN) else {
            print("use file *.asm")
            return
        }
        let pathMatch = path.firstMatch(pattern: FILE_PATH_PATTERN)
        let filenameRange = pathMatch?.range(at: 1)
        let filename = path[filenameRange!]
        
        guard let data = fileManager.contents(atPath: path),
            let contents = String(data: data, encoding: .ascii) else {
                print("error: cannot find file.")
                return
        }
        
        for line in contents.components(separatedBy: .newlines) {
            
            instruction = line.trimmingCharacters(in: .whitespaces)
            if instruction.isEmpty { continue }
            if isMatch(pattern: "^/{2}") { continue }
            
            let type = commandType()
            switch type {
            case .a:
                let match = firstMatch(pattern: A_COMMAND_PATTERN)
                let range = match?.range(at: 1)
                let value = instruction[range!]
                result += formatBinary(Int(value)!, figureLength: 16)
                result += "\n"
            case .c:
                let destCode = Code.dest(dest())
                let compCode = Code.comp(comp())
                let jumpCode = Code.jump(jump())
                result += "111\(formatBinary(destCode, figureLength: 3))\(formatBinary(compCode, figureLength: 7))\(formatBinary(jumpCode, figureLength: 3))"
                result += "\n"
            case .l:
                print("L")
            }
        }
        
        let resultData = result.data(using: .ascii)
        fileManager.createFile(atPath: "./\(filename).hack", contents: resultData, attributes: nil)
    }
    
    func formatBinary(_ val: Int, figureLength: Int) -> String {
        var binary = String(val, radix: 2)
        let count = binary.count
        for _ in 0..<figureLength-count {
            binary.insert("0", at: binary.startIndex)
        }
        return binary
    }
    
    func hasMoreCommands() -> Bool {
        return true
    }
    
    func advance() {
        guard hasMoreCommands() else { return }
    }
    
    func commandType() -> CommandType {
        if isMatch(pattern: A_COMMAND_PATTERN) {
            return .a
        } else if isMatch(pattern: L_COMMAND_PATTERN) {
            return .l
        } else {
            return .c
        }
    }
    
    // func symbol() -> String {
    // }
    
    func dest() -> String {
        let match = firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 1)
        return instruction[range!]
    }
    
    func comp() -> String {
        let match = firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 2)
        return instruction[range!]
    }
    
    func jump() -> String {
        let match = firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 3)
        return instruction[range!]
    }
    
    private func isMatch(pattern: String) -> Bool {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return false }
        let count = regExp.numberOfMatches(in: instruction, options: [], range: NSMakeRange(0, instruction.count))
        return count != 0
    }
    
    func firstMatch(pattern: String) -> NSTextCheckingResult? {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return nil }
        let matche = regExp.firstMatch(in: instruction, options: [], range: NSMakeRange(0, instruction.count))
        return matche
    }
}

enum CommandType {
    case a
    case c
    case l
}

extension String {
    
    subscript(range: NSRange) -> String {
        if range.lowerBound == NSNotFound {
            return ""
        }
        
        let nsString = self as NSString
        let subString = nsString.substring(with: range)
        return String(subString)
    }
    
    func isMatch(pattern: String) -> Bool {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return false }
        let count = regExp.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.count))
        return count != 0
    }
    
    func firstMatch(pattern: String) -> NSTextCheckingResult? {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return nil }
        let matche = regExp.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count))
        return matche
    }
}
