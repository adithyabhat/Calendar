//
//  Constants.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 03/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct CalendarRange {
        static let startYear = 2010
        static let endYear = 2025
    }
    struct CalendarLayout {
        static let monthsInARow = 3
        static let daysInAWeek = 7
        static let monthsInAYear = 12
    }
    struct FontSize {
        static let thumbnailDateDisplay = CGFloat(10.0)
        static let monthCalendarDateDisplay = CGFloat(15.0)
    }
    struct CellIdentifier {
        static let emptyCellReuseIdentifier = "EmptyCollectionViewCell"
    }
    struct SegueIdentifier {
        static let showMonthExpandedSegueIdentifier = "showMonthExpandedSegueIdentifier"
    }
    struct WeatherInfo {
        static let baseURL = "https://api.darksky.net/forecast/b21b08db0e8645451b563620fd58db47/"
    }
}
