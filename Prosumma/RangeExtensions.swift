//
//  RangeExtensions.swift
//  Prosumma
//
//  Created by Gregory Higley on 10/2/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import Foundation

public func +<E: IntegerArithmeticType>(lhs: Range<E>, rhs: Range<E>) -> Range<E> {
    let lhsDistance = lhs.startIndex.distanceTo(lhs.endIndex)
    let rhsDistance = rhs.startIndex.distanceTo(rhs.endIndex)
    let distance = lhsDistance + rhsDistance
    let startIndex = lhs.startIndex + rhs.startIndex
    let endIndex = startIndex.advancedBy(distance - 1)
    return startIndex..<endIndex
}