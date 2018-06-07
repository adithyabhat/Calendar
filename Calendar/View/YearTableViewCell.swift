//
//  AYearCalendarTableViewCell.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 01/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

//TableViewCell instance, that displays all the months dates in a year
class YearTableViewCell: UITableViewCell {
    static let reuseIdentifier = "YearTableViewCell"
    var allThumbnailViews = [ThumbnailMonthView]()
    @IBOutlet weak var verticalStackView: UIStackView!

    //MARK: Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        //Add ThumbnailMonthView instances to display each month dates
        if let rowStackViews = verticalStackView.arrangedSubviews as? [UIStackView] {
            for stackView in rowStackViews {
                for _ in 0..<Constants.CalendarLayout.monthsInARow {
                    let thumbnailMonthView = ThumbnailMonthView.instance()
                    stackView.addArrangedSubview(thumbnailMonthView)
                    allThumbnailViews.append(thumbnailMonthView)
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        allThumbnailViews.forEach { (thumbnailMonthView) in
            thumbnailMonthView.clearAllLabels()
        }
    }
    
    //MARK: Public methods
    func configureCell(forYear year: Int, withDelegate delegate: ThumbnailMonthViewDelegate) {
        if allThumbnailViews.count <= 12 {
            for (index, thumbnailView) in allThumbnailViews.enumerated() {
                thumbnailView.configureView(forYear: year, month: index + 1, withDelegate: delegate)
            }
        }
    }
}
