//
//  log.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/21.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

class Log {
    
    var log: String = ""
    
    func addLog(lineCount: Int, instruction: String, type: CommandType, output: String) {
        let line = "\(lineCount) \(instruction) type=\(type.rawValue) output=\(output)"
        add(line)
    }
    
    private func add(_ text: String) {
        log += text
    }
    
    func output(filename: String) {
        let data = log.data(using: .utf8)
        let fileManager = FileManager.default
        guard fileManager.createFile(atPath: "\(filename).log", contents: data) else {
            return
        }
        print("log -> \(filename).log")
    }
}
