//
//  RegExpPattern.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/24.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

struct RegExpPattern {
    static let FILE_PATH_PATTERN = "([\\w\\.\\$\\~:/]+)\\.asm$"
    static let A_COMMAND_PATTERN = "@((\\d+)|([\\w\\.\\$:]+))"
    static let C_COMMAND_PATTERN = "(?:(A?M?D?)=)?([^;]+)(?:;(.+))?"
    static let L_COMMAND_PATTERN = "\\(([\\w\\.\\$:]+)\\)"
    static let COMMENT_OUT_PATTERN = "/{2}.*"
}
