//
//  main.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/19.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

func run() {
    
    guard #available(macOS 10.12, *) else {
        print("The current environment is not macOS 10.12 or newer.")
        return
    }
    
    guard CommandLine.argc == 2 else {
        print("usage: ./assembler FILEPATH")
        return
    }
    
    let args = CommandLine.arguments
    let filePath = args[1]
    
    let parser = Parser.init(path: filePath)
    parser.advance()
    parser.output()
}

run()
