//
//  AgendaTableViewCell.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 07/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class AgendaTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AgendaTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: Public method
    func configureView(forAgenda agenda: Agenda) {
        titleLabel.text = agenda.title
        locationLabel.text = agenda.location ?? "No Location specified"
        startTimeLabel.text = Formatter.timeFormatter.string(from: agenda.startTime! as Date).uppercased()
        durationLabel.text = Formatter.timeFormatter.string(from: agenda.endTime! as Date).uppercased()
    }
}
