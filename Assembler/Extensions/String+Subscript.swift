//
//  String+Subscript.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/21.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

extension String {
    
    subscript(range: NSRange) -> String {
        if range.lowerBound == NSNotFound {
            return ""
        }
        
        let nsString = self as NSString
        let subString = nsString.substring(with: range)
        return String(subString)
    }
}
