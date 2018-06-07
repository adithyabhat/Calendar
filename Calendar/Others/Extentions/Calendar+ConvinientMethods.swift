//
//  Calendar+ConvinientMethods.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 28/02/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import Foundation

enum WeekDay: Int {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

enum MonthNameFormat {
    case short
    case full
}

extension Calendar {
    //Returns the weekday for the provided date
    static func weekday(forDay day: Int, month: Int, year: Int) -> WeekDay? {
        var weekday: WeekDay?
        //Form datecomponent from the input values
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        let calendar = Calendar.current
        //get date from the datecomponent
        guard let date = calendar.date(from: dateComponents) else {
            return weekday
        }
        //extract weekday from the date generated
        let weekDayInt = Calendar.current.component(.weekday, from: date)
        weekday = WeekDay(rawValue: weekDayInt - 1)
        return weekday
    }
    
    static func lastDayOfMonth(month: Int, year: Int) -> Int? {
        guard month > 0 && month <= 12 else {
            return nil
        }
        let calendar = Calendar.current
        //+1 to goto the next month and then subtract a day to get the last date
        let monthValue = (month + 1) % 12
        var yearValue = year
        if monthValue == 1 {
            yearValue += 1
        }
        let referenceDateComponent = DateComponents(calendar: calendar,
                                                    timeZone: TimeZone(identifier: "GMT"),
                                                    year: yearValue,
                                                    month: monthValue,
                                                    day: 1)
        let prevDate = calendar.date(byAdding: .day, value: -1, to: calendar.date(from: referenceDateComponent)!)!
        return calendar.component(.day, from: prevDate)
    }
    
    //Returns month string for the specified month index
    //Returns in "LLL" format for the "short" format, full month name for "full" format
    static func monthName(forMonth month: Int, format: MonthNameFormat) -> String? {
        guard month >= 1 && month <= 12 else {
            return nil
        }
        let dateComponent = DateComponents(month: month)
        if let date = Calendar.current.date(from: dateComponent) {
            var monthName: String
            switch format {
            case .short:
                monthName = Formatter.monthShortFormatter.string(from: date)
            case .full:
                monthName = Formatter.monthFullFormatter.monthSymbols[month - 1]
            }
            return monthName
        }
        return nil
    }
    
    //Returns number of weeks in a month
    static func weekCountInMonth(month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        if let dateInMonth = calendar.date(from: DateComponents(year: year, month: month)),
            let weekRange = calendar.range(of: .weekOfYear, in: .month, for: dateInMonth) {
            return weekRange.count
        }
        return nil
    }
}
