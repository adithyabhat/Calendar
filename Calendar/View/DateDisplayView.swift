//
//  DateDisplayView.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 03/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class DateDisplayView: UIView {
    private var dateString = String()
    var isDateToday = false
    
    //MARK: Standard methods
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Overide methods
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard dateString.isEmpty == false else {
            return
        }
        //If date is today's date, need to mark it with a circluar background
        if isDateToday, let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(UIColor.black.cgColor)
            //diameter of the circular background
            let diameter = min(self.bounds.size.width, self.bounds.size.height)
            var circleRect = self.bounds
            circleRect.origin.y = self.bounds.size.height / 2 - diameter / 2
            circleRect.size.height = diameter
            circleRect.size.width = diameter
            //draw circular background
            context.fillEllipse(in: circleRect)
        }
        //Draw the date value
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let fontSize = Constants.FontSize.thumbnailDateDisplay
        let attributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.foregroundColor: isDateToday ? UIColor.white : UIColor.darkGray]
            as [NSAttributedStringKey: Any]
        //Set text frame
        let textHeight = NSString(string: dateString).size(withAttributes: attributes).height
        var textRect = self.bounds
        textRect.origin.y = self.bounds.size.height / 2 - textHeight / 2
        //Draw date string
        NSString(string: dateString).draw(in: textRect, withAttributes: attributes)
    }
    
    //MARK: Public method
    func set(dateString: String) {
        self.dateString = dateString
        self.setNeedsDisplay()
    }
}
