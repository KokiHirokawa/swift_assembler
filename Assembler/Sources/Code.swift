//
//  code.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/19.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

struct Code {
    
    private static let compDict: [String: String] = [
        "0":   "0101010",
        "1":   "0111111",
        "-1":  "0111010",
        "D":   "0001100",
        "A":   "0110000",
        "M":   "1110000",
        "!D":  "0001101",
        "!A":  "0110001",
        "!M":  "1110001",
        "-D":  "0001111",
        "-A":  "0110011",
        "-M":  "1110011",
        "D+1": "0011111",
        "A+1": "0110111",
        "M+1": "1110111",
        "D-1": "0001110",
        "A-1": "0110010",
        "M-1": "1110010",
        "D+A": "0000010",
        "D+M": "1000010",
        "D-A": "0010011",
        "D-M": "1010011",
        "A-D": "0000111",
        "M-D": "1000111",
        "D&A": "0000000",
        "D&M": "1000000",
        "D|A": "0010101",
        "D|M": "1010101"
    ]
    
    private static let destDict: [String: String] = [
        "null": "000",
        "M":    "001",
        "D":    "010",
        "MD":   "011",
        "A":    "100",
        "AM":   "101",
        "AD":   "110",
        "AMD":  "111"
    ]
    
    private static let jumpDict: [String: String] = [
        "null": "000",
        "JGT":  "001",
        "JEQ":  "010",
        "JGE":  "011",
        "JLT":  "100",
        "JNE":  "101",
        "JLE":  "110",
        "JMP":  "111"
    ]
    
    static func dest(_ mnemonic: String) -> String {
        if mnemonic.isEmpty {
            return Code.destDict["null"]!
        }
        return Code.destDict[mnemonic]!
    }
    
    static func comp(_ mnemonic: String) -> String {
        return Code.compDict[mnemonic]!
    }
    
    static func jump(_ mnemonic: String) -> String {
        if mnemonic.isEmpty {
            return Code.jumpDict["null"]!
        }
        return Code.jumpDict[mnemonic]!
    }
}
