//
//  Formatter+MonthFormatter.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 03/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import Foundation

extension Formatter {
    static let monthShortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    static let monthFullFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}
