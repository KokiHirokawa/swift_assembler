//
//  String+RegularExpression.swift
//  Assembler
//
//  Created by KokiHirokawa on 2019/03/21.
//  Copyright © 2019 KokiHirokawa. All rights reserved.
//

import Foundation

extension String {
 
    func isMatch(pattern: String) -> Bool {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return false }
        let count = regExp.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.count))
        return count != 0
    }
    
    func firstMatch(pattern: String) -> NSTextCheckingResult? {
        guard let regExp = try? NSRegularExpression(pattern: pattern) else { return nil }
        let matche = regExp.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count))
        return matche
    }
}
