//
//  UITableViewCellExtensions.swift
//  Prosumma
//
//  Created by Gregory Higley on 8/4/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import ObjectiveC
import UIKit

extension UITableViewCell {
    
    // Used for reuseIdentifier and name of NIB.
    public class var cellName: String {
        let pointer = class_getName(self)
        let name = String.fromCString(UnsafePointer<CChar>(pointer))!
        guard let range = name.rangeOfString(".") else {
            return name
        }
        return name.substringFromIndex(range.endIndex)
    }
    
}