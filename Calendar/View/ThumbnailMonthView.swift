//
//  ThumbnailMonthView.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 01/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

protocol ThumbnailMonthViewDelegate: class {
    func selected(month: Int)
}

//Displays all the dates in a month
class ThumbnailMonthView: UIView {
    var dateDisplayViews = [DateDisplayView]()
    weak var delegate: ThumbnailMonthViewDelegate?
    var displayingMonth: Int = 0
    //stackview which contains all the 6 row stackviews
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var monthNameLabel: UILabel!
    
    static func instance() -> ThumbnailMonthView {
        return Bundle.loadNib(nibName: "ThumbnailMonthView", type: ThumbnailMonthView.self)
    }
    
    //MARK: Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        //Add all the labels to display the dates
        if let rowStackViews = verticalStackView.arrangedSubviews as? [UIStackView] {
            for stackView in rowStackViews {
                for _ in 0..<Constants.CalendarLayout.daysInAWeek {
                    let dateDisplayView = DateDisplayView()
                    stackView.addArrangedSubview(dateDisplayView)
                    dateDisplayViews.append(dateDisplayView)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.selected(month: displayingMonth)
    }
    
    //MARK: Public methods
    func clearAllLabels() {
        dateDisplayViews.forEach { (dateDisplayView) in
            dateDisplayView.set(dateString: "")
            dateDisplayView.isDateToday = false
        }
    }
    
    func configureView(forYear year: Int, month: Int, withDelegate delegate: ThumbnailMonthViewDelegate) {
        displayingMonth = month
        self.delegate = delegate
        guard let startWeekDayIndex = Calendar.weekday(forDay: 1, month: month, year: year)?.rawValue,
            let lastDay = Calendar.lastDayOfMonth(month: month, year: year) else {
            return
        }
        //Month label name
        monthNameLabel.text = Calendar.monthName(forMonth: month, format: .short)
        //Fill all date labels
        var viewIndex = startWeekDayIndex
        for index in 1...lastDay {
            let dateDisplayView = dateDisplayViews[viewIndex]
            dateDisplayView.set(dateString: "\(index)")
            viewIndex += 1
            //hightlight current day
            let currentDate = Calendar.current.dateComponents([.day, .month, .year], from: Date())
            if let currentDay = currentDate.day, currentDay == index,
                let currentMonth = currentDate.month, currentMonth == month,
                let currentYear = currentDate.year, currentYear == year
                {
                dateDisplayView.isDateToday = true
            }
        }
    }
}
