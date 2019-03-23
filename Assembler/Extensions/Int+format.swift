//
//  Int+format.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/24.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

extension Int {
    
    func format(radix: Int, length: Int) -> String? {
        
        var output = String(self, radix: radix)
        let addCount = length - output.count
        guard addCount > 0 else { return nil }
        
        for _ in 0..<length-output.count {
            output.insert("0", at: output.startIndex)
        }
        return output
    }
}
