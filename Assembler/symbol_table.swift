//
//  symbol_table.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/20.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

class SymbolTable {
    
    var symbols: [String: String] = [
        "SP":     "0000000000000000",
        "LCL":    "0000000000000001",
        "ARG":    "0000000000000002",
        "THIS":   "0000000000000003",
        "THAT":   "0000000000000004",
        "R0":     "0000000000000000",
        "R1":     "0000000000000001",
        "R2":     "0000000000000010",
        "R3":     "0000000000000011",
        "R4":     "0000000000000100",
        "R5":     "0000000000000101",
        "R6":     "0000000000000110",
        "R7":     "0000000000000111",
        "R8":     "0000000000001000",
        "R9":     "0000000000001001",
        "R10":    "0000000000001010",
        "R11":    "0000000000001011",
        "R12":    "0000000000001100",
        "R13":    "0000000000001101",
        "R14":    "0000000000001110",
        "R15":    "0000000000001111",
        "SCREEN": "0100000000000000",
        "KBD":    "0110000000000000"
    ]
    
    func addEntry(symbol key: String, address: String) {
        symbols[key] = address
    }
    
    func contains(symbol key: String) -> Bool {
        guard let _ = symbols[key] else { return false }
        return true
    }
    
    func getAddress(symbol key: String) -> String {
        return symbols[key] ?? ""
    }
}
