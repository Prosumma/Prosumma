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
                result.appendContentsOf(replacement)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    public func stringByRemovingDiacritics(except exceptions: String = "") -> String? {
        guard let data = dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true) else {
            return nil
        }
        guard var s = String(data: data, encoding: NSASCIIStringEncoding) else {
            return nil
        }
        if characters.count != s.characters.count {
            return nil
        }
        for exception in exceptions.characters.map({String($0)}) {
            var range: Range<String.Index>? = nil
            while true {
                range = rangeOfString(exception, options: [], range: range, locale: nil)
                if range == nil {
                    break
                }
                s.replaceRange(range!, with: exception)
                range = range!.startIndex.advancedBy(1)..<endIndex
            }
        }
        return s
    }
    
    public func reverse() -> String {
        return String(characters.reverse())
    }
}

