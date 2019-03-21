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
    
    let A_COMMAND_PATTERN = "@(\\d+)|([\\w\\.\\$:]+)"
    let C_COMMAND_PATTERN = "(?:(A?M?D?)=)?([^;]+)(?:;(.+))?"
    let L_COMMAND_PATTERN = "\\(([\\w\\.\\$:]+)\\)"
    let COMMENT_OUT_PATTERN = "^/{2}"
    let FILE_PATH_PATTERN = "([\\w\\.\\$:]+)\\.asm$"
    
    var instruction: String!
    var result: String = ""
    
    let symbolTable = SymbolTable()
    let log = Log()
    
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
        
        var lineCount = 1
        
        for line in contents.components(separatedBy: .newlines) {
            instruction = line.trimmingCharacters(in: .whitespaces)
            if instruction.isEmpty { continue }
            if isMatch(pattern: COMMENT_OUT_PATTERN) { continue }
            
            let type = commandType()
            switch type {
            case .a:
                let match = instruction.firstMatch(pattern: A_COMMAND_PATTERN)
                guard let range = match?.range(at: 2) else { continue }
                let symbol = instruction[range]
                symbolTable.addVariable(symbol: symbol)
            case .c:
                break
            case .l:
                let match = instruction.firstMatch(pattern: L_COMMAND_PATTERN)
                guard let range = match?.range(at: 1) else { continue }
                let symbol = instruction[range]
                guard let address = lineCount.format(radix: 2, length: 16) else { continue }
                symbolTable.addEntry(symbol: symbol, address: address)
            }
            
            lineCount += 1
        }
        
        lineCount = 0
        
        for line in contents.components(separatedBy: .newlines) {
            
            instruction = line.trimmingCharacters(in: .whitespaces)
            if instruction.isEmpty { continue }
            if isMatch(pattern: COMMENT_OUT_PATTERN) { continue }
            
            let type = commandType()
            var output = ""
            switch type {
            case .a:
                let match = firstMatch(pattern: A_COMMAND_PATTERN)
                if let symbolRange = match?.range(at: 2) {
                    let symbol = instruction[symbolRange]
                    let value = symbolTable.getAddress(symbol: symbol)
                    output += value
                } else if let addressRange = match?.range(at: 1) {
                    let value = instruction[addressRange]
                    output += Int(value)?.format(radix: 2, length: 16) ?? ""
                }
            case .c:
                let destCode = Code.dest(dest())
                let compCode = Code.comp(comp())
                let jumpCode = Code.jump(jump())
                output += "111\(destCode)\(compCode)\(jumpCode)"
            case .l:
                print("L")
            }
            
            lineCount += 1
            log.addLog(lineCount: lineCount, instruction: instruction, type: type, output: output)
            output += "\n"
            result += output
        }
        
        let resultData = result.data(using: .ascii)
        fileManager.createFile(atPath: "./\(filename).hack", contents: resultData, attributes: nil)
        
        log.output()
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
