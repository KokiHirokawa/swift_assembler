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
    
    let path = arguments[1]
    _ = Parser.init(path)
}

main(CommandLine.arguments)
