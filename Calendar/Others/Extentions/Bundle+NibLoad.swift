//
//  Bundle+NibLoad.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 02/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import Foundation

extension Bundle {
    static func loadNib<T>(nibName name: String, type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("Could not load nib \(name)")
    }
}
