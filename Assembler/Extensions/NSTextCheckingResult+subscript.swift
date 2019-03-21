//
//  NSTextCheckingResult+subscript.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/21.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

extension NSTextCheckingResult {
    
    subscript(_ index: Int) -> NSRange? {
        guard index < numberOfRanges else { return nil }
        
        let result = range(at: index)
        guard result.lowerBound != NSNotFound else { return nil }
        
        return result
    }
}
