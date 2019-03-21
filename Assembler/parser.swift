//
//  parser.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/19.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

class Parser {
    
    let A_COMMAND_PATTERN = "@((\\d+)|([\\w\\.\\$:]+))"
    let C_COMMAND_PATTERN = "(?:(A?M?D?)=)?([^;]+)(?:;(.+))?"
    let L_COMMAND_PATTERN = "\\(([\\w\\.\\$:]+)\\)"
    let COMMENT_OUT_PATTERN = "/{2}.*"
    
    let fileManager = FileManager.default
    let symbolTable = SymbolTable()
    let log = Log()
    
    var inputCode: String = ""
    var outputCode: String = ""
    
    var instruction: String = ""
    
    init(path: String) {
        guard let data = fileManager.contents(atPath: path),
            let inputCode = String(data: data, encoding: .ascii) else {
                print("error: cannot find file.")
                return
        }
        
        self.inputCode = inputCode
    }
    
    func advance() {
        var lineCount = 0
        
        for line in inputCode.components(separatedBy: .newlines) {
            
            instruction = line
            
            let regExp = try! NSRegularExpression(pattern: COMMENT_OUT_PATTERN)
            instruction = regExp.stringByReplacingMatches(in: instruction, range: NSMakeRange(0, instruction.count), withTemplate: "")
            instruction = instruction.trimmingCharacters(in: .whitespaces)
            
            if instruction.isEmpty { continue }
            
            let type = commandType()
            switch type {
            case .a, .c:
                lineCount += 1
            case .l:
                let value = symbol(type)
                guard let address = lineCount.format(radix: 2, length: 16) else { continue }
                symbolTable.addEntry(symbol: value, address: address)
            }
        }
        
        lineCount = 0
        
        for line in inputCode.components(separatedBy: .newlines) {
            
            instruction = line
            
            let regExp = try! NSRegularExpression(pattern: COMMENT_OUT_PATTERN)
            instruction = regExp.stringByReplacingMatches(in: instruction, range: NSMakeRange(0, instruction.count), withTemplate: "")
            instruction = instruction.trimmingCharacters(in: .whitespaces)
            
            if instruction.isEmpty { continue }
            
            let type = commandType()
            var output = ""
            switch type {
            case .a:
                guard let match = instruction.firstMatch(pattern: A_COMMAND_PATTERN) else { continue }
                
                if let addressRange = match[2] {
                    let value = instruction[addressRange]
                    output += Int(value)!.format(radix: 2, length: 16)!
                } else if let symbolRange = match[3] {
                    let symbol = instruction[symbolRange]
                    if symbolTable.contains(symbol: symbol) {
                        output += symbolTable.getAddress(symbol: symbol)
                    } else {
                        symbolTable.addVariable(symbol: symbol)
                        output += symbolTable.getAddress(symbol: symbol)
                    }
                }
                output += "\n"
                lineCount += 1
            case .c:
                let destCode = Code.dest(dest())
                let compCode = Code.comp(comp())
                let jumpCode = Code.jump(jump())
                output += "111\(compCode)\(destCode)\(jumpCode)"
                output += "\n"
                lineCount += 1
            case .l:
                break
            }
            
            outputCode += output
            log.addLog(lineCount: lineCount, instruction: instruction, type: type, output: output)
        }
    }
    
    func output(filename: String) {
        let data = outputCode.data(using: .ascii)
        fileManager.createFile(atPath: "\(filename).hack", contents: data)
        
        log.output(filename: filename)
    }
    
    func commandType() -> CommandType {
        if let _ = instruction.firstMatch(pattern: L_COMMAND_PATTERN) {
            return .l
        } else if let _ = instruction.firstMatch(pattern: A_COMMAND_PATTERN) {
            return .a
        } else {
            return .c
        }
    }
    
    func symbol(_ type: CommandType) -> String {
        switch type {
        case .a:
            return instruction[NSMakeRange(1, instruction.count - 1)]
        case .l:
            return instruction[NSMakeRange(1, instruction.count - 2)]
        case .c:
            return ""
        }
    }
    
    func dest() -> String {
        let match = instruction.firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 1)
        return instruction[range!]
    }
    
    func comp() -> String {
        let match = instruction.firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 2)
        return instruction[range!]
    }
    
    func jump() -> String {
        let match = instruction.firstMatch(pattern: C_COMMAND_PATTERN)
        let range = match?.range(at: 3)
        return instruction[range!]
    }
}
