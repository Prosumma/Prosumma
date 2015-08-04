//
//  UITableViewExtensions.swift
//  Prosumma
//
//  Created by Gregory Higley on 8/4/15.
//  Copyright © 2015 Prosumma LLC. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func registerCell<C: UITableViewCell>(cellType: C.Type) {
        let cellName = C.cellName
        let nib = UINib(nibName: cellName, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: cellName)
    }
    
}