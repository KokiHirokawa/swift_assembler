//
//  log.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/21.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

class Log {
    
    var log: String
    
    init() {
        log = ""
    }
    
    func addLog(lineCount: Int, instruction: String, type: CommandType, output: String) {
        let line = "\(lineCount) \(instruction) type=\(type.rawValue) output=\(output)"
        add(line)
    }
    
    private func add(_ text: String) {
        log += text
        log += "\n"
    }
    
    func output() {
        let data = log.data(using: .utf8)
        let fileManager = FileManager.default
        guard fileManager.createFile(atPath: "./output.log", contents: data) else {
            return
        }
        print("log -> output.log")
    }
}
