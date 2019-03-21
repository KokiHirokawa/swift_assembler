//
//  main.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/19.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

func main(_ arguments: [String]) {
    
    guard #available(macOS 10.12, *) else {
        print("The current environment is not macOS 10.12 or newer.")
        return
    }
    
    if CommandLine.argc < 2 {
        print("No arguments are passed.")
        print("usage: ./assembler FILEPATH")
        return
    }
    
    let filePath = arguments[1]
    let parser = Parser.init(path: filePath)
    parser.advance()
    
    let FILE_PATH_PATTERN = "([\\w\\.\\$\\~:/]+)\\.asm$"
    guard let pathMatch = filePath.firstMatch(pattern: FILE_PATH_PATTERN), let filenameRange = pathMatch[1] else {
        print("please pass *.asm file.")
        return
    }
    parser.output(filename: filePath[filenameRange])
}

main(CommandLine.arguments)
