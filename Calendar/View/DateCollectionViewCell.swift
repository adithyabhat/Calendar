//
//  DateCollectionViewCell.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 06/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DateCollectionViewCell"
    private var dateString = String()
    private var numberOfAgendaForToday = 0
    private var shouldHighlight = false
    
    //MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shouldHighlight = false
        dateString = ""
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard dateString.isEmpty == false else {
            return
        }
        
        //if cell is selected, draw background
        if shouldHighlight, let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.black.withAlphaComponent(0.3).cgColor)
            context.fill(self.bounds)
        }
        
        //Draw the date value
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let fontSize = Constants.FontSize.monthCalendarDateDisplay
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.foregroundColor: shouldHighlight ? UIColor.white : UIColor.darkGray]
            as [NSAttributedStringKey: Any]
        //Set text frame
        let textHeight = NSString(string: dateString).size(withAttributes: attributes).height
        var textRect = self.bounds
        textRect.origin.y = self.bounds.size.height / 2 - textHeight / 2
        //Draw date string
        NSString(string: dateString).draw(in: textRect, withAttributes: attributes)
        
        //If there are agenda for this date, mark it with a dot
        if numberOfAgendaForToday > 0, let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color(forAgendaCount: numberOfAgendaForToday).cgColor)
            //diameter of the circular dot
            let diameter = self.bounds.size.width / 10
            let circleRect = CGRect(x: self.bounds.size.height / 2 - diameter / 2,
                                    y: self.bounds.size.height * 3 / 4,
                                    width: diameter,
                                    height: diameter)
            //draw circular dot
            context.fillEllipse(in: circleRect)
        }
    }
    
    //MARK: Private helper methods
    //returns color green if the count is less, red if count is more
    private func color(forAgendaCount count: Int) -> UIColor {
        var color: UIColor
        switch count {
        case 0...4:
            color = UIColor.green
        default:
            color = UIColor.red
        }
        return color.withAlphaComponent(0.75)
    }
    
    //MARK: Public methods
    func set(dateString: String, numberOfAgendaForToday: Int) {
        self.dateString = dateString
        self.numberOfAgendaForToday = numberOfAgendaForToday
        self.setNeedsDisplay()
    }
    
    func set(selected: Bool) {
        shouldHighlight = selected
        setNeedsDisplay(self.bounds)
    }
}
