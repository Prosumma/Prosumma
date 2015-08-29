//
//  NSStringExtensions.swift
//  Prosumma
//
//  Created by Gregory Higley on 8/12/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import Foundation

extension String {
    public func stringByReplacingCharactersInSet(characterSet: NSCharacterSet, withString replacement: String) -> String {
        var result = ""
        for character in unicodeScalars {
            if characterSet.longCharacterIsMember(character.value) {
                result.extend(replacement)
            } else {
                result.append(character)
            }
        }
        return result
    }
}

