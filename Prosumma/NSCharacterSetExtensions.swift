//
//  NSCharacterSetExtensions.swift
//  Prosumma
//
//  Created by Gregory Higley on 8/12/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import Foundation

public func +(lhs: NSCharacterSet, rhs: NSCharacterSet) -> NSCharacterSet {
    let result = NSMutableCharacterSet()
    result.formUnionWithCharacterSet(lhs)
    result.formUnionWithCharacterSet(rhs)
    return result
}