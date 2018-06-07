//
//  AgendaTableViewController.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 05/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class AgendaTableViewController: UITableViewController {
    private var dataSource = [Int: [Agenda]]()
    var selectedDate: Int?
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadAllAgenda()
    }

    //MARK : Private helper methods
    private func setUpUI() {
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
    }
    
    private func loadAllAgenda() {
        if let allAgenda = Agenda.fetchAllAgenda() {
            for agenda in allAgenda {
                var agendaList = dataSource[Int(agenda.date)]
                if agendaList == nil {
                    agendaList = [Agenda]()
                }
                agendaList?.append(agenda)
                dataSource[Int(agenda.date)] = agendaList
            }
        }
    }
    
    //MARK: Public method
    func update(forDate date: Int) {
        selectedDate = date
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if let selectedDate = selectedDate, let agendaList = dataSource[selectedDate] {
            numberOfRows = agendaList.count
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AgendaTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        guard let agendaTableViewCell = cell as? AgendaTableViewCell else {
            fatalError("Custom cell did not load. Check")
        }
        if let selectedDate = selectedDate, let agendaList = dataSource[selectedDate] {
            agendaTableViewCell.configureView(forAgenda: agendaList[indexPath.row])
        }
        return cell
    }
}
