//
//  CalendarTests.swift
//  CalendarTests
//
//  Created by Bhat, Adithya H on 08/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import XCTest
@testable import Calendar

class CalendarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //Test all Calendar convinience methods
    //Test func weekday(forDay day: Int, month: Int, year: Int) -> WeekDay?
    func testWeekDayValueFunction() {
        var weekDay = Calendar.weekday(forDay: 1, month: 1, year: 2018)
        XCTAssertEqual(weekDay, WeekDay.monday, "Weekday calculated is wrong")
        
        weekDay = Calendar.weekday(forDay: 2, month: 4, year: 2018)
        XCTAssertEqual(weekDay, WeekDay.monday, "Weekday calculated is wrong")

        weekDay = Calendar.weekday(forDay: 12, month: 6, year: 2004)
        XCTAssertEqual(weekDay, WeekDay.saturday, "Weekday calculated is wrong")

        weekDay = Calendar.weekday(forDay: 12, month: 6, year: 2004)
        XCTAssertEqual(weekDay, WeekDay.saturday, "Weekday calculated is wrong")
        
        weekDay = Calendar.weekday(forDay: 29, month: 2, year: 2008)
        XCTAssertEqual(weekDay, WeekDay.friday, "Weekday calculated is wrong")
    }
    
    //Test func lastDayOfMonth(month: Int, year: Int) -> Int?
    func testLastDayOfMonthFunction() {
        var lastDay = Calendar.lastDayOfMonth(month: 4, year: 2018)
        XCTAssertEqual(lastDay, 30, "Lastday calculated is wrong")
        
        lastDay = Calendar.lastDayOfMonth(month: 6, year: 2000)
        XCTAssertEqual(lastDay, 30, "Lastday calculated is wrong")
        
        lastDay = Calendar.lastDayOfMonth(month: 2, year: 2000)
        XCTAssertEqual(lastDay, 29, "Lastday calculated is wrong")
        
        lastDay = Calendar.lastDayOfMonth(month: 5, year: 2020)
        XCTAssertEqual(lastDay, 31, "Lastday calculated is wrong")
        
        lastDay = Calendar.lastDayOfMonth(month: 12, year: 2006)
        XCTAssertEqual(lastDay, 31, "Lastday calculated is wrong")
    }
    
    //Test func monthName(forMonth month: Int, format: MonthNameFormat) -> String?
    func testMonthNameFunction() {
        var monthName = Calendar.monthName(forMonth: 2, format: .full)
        XCTAssertEqual(monthName, "February", "Month name is wrong")
        
        monthName = Calendar.monthName(forMonth: 4, format: .full)
        XCTAssertEqual(monthName, "April", "Month name is wrong")
        
        monthName = Calendar.monthName(forMonth: 6, format: .full)
        XCTAssertEqual(monthName, "June", "Month name is wrong")
        
        monthName = Calendar.monthName(forMonth: 6, format: .short)
        XCTAssertEqual(monthName, "Jun", "Month name is wrong")
        
        monthName = Calendar.monthName(forMonth: 8, format: .short)
        XCTAssertEqual(monthName, "Aug", "Month name is wrong")
        
        monthName = Calendar.monthName(forMonth: 12, format: .short)
        XCTAssertEqual(monthName, "Dec", "Month name is wrong")
    }
    
    //Test sample Agenda data
    func testSampleDataRetrieving() {
        let isDataLoaded = AgendaDataLoader.isDataLoaded()
        if isDataLoaded == false {
            AgendaDataLoader.loadSampleData()
        }
        //fetch data
        let result = (Agenda.fetchAllAgenda() ?? []).count
        XCTAssertEqual(result, 22, "Month name is wrong")
    }
}
