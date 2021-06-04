//
//  Bool+Extensions.swift
//  proj_DOD
//
//  Created by 이주혁 on 2021/05/30.
//

import Foundation


extension Bool {
    var toNSNumber: NSNumber {
        return NSNumber(booleanLiteral: self)
    }
}
