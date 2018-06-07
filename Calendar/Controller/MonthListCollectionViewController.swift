//
//  MonthListCollectionViewController.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 06/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class MonthListCollectionViewController: UICollectionViewController {
    let monthsInAYear = Constants.CalendarLayout.monthsInAYear
    //The month that is selected from the previous screen
    var selectedMonth: SelectedMonth?
    //Holds count of agenda's for each date
    private var agendaCountHolder = [Int: Int]()
    private var currentSelectedCellIndexPath: IndexPath?
    private var currentShowingMonthIndexValueHolder: Int = 0
    private var currentShowingMonthIndex: Int {
        get {
            return currentShowingMonthIndexValueHolder
        }
        set {
            currentShowingMonthIndexValueHolder = newValue
            initiateParentViewUpdates()
        }
    }
    //list of all the start day index of every month
    private lazy var startWeekDayIndexes: [Int] = {
        if let selectedMonth = selectedMonth {
            var indexes = [Int]()
            for i in 1...12 {
                indexes.append(Calendar.weekday(forDay: 1, month: i, year: selectedMonth.year)!.rawValue)
            }
            return indexes
        }
        return []
    }()
    //list of last days of each month
    private lazy var lastDays: [Int] = {
        if let selectedMonth = selectedMonth {
            var lastDayOfMonths = [Int]()
            for i in 1...12 {
                lastDayOfMonths.append(Calendar.lastDayOfMonth(month: i, year: selectedMonth.year)!)
            }
            return lastDayOfMonths
        }
        return []
    }()
    private lazy var formattedDate: Date = {
        let calendar = Calendar.current
        let todaysDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        return calendar.date(from: todaysDateComponents)!
    }()
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadAgendaCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        if selectedMonth != nil {
            scroll(toMonth: selectedMonth!.month, animated: false)
        }
    }
    
    //MARK: Private helper methods
    private func setUpUI() {
        //Collection view
        collectionView?.register(EmptyCollectionViewCell.self,
                                 forCellWithReuseIdentifier: EmptyCollectionViewCell.reuseIdentifier)
        collectionView?.register(DateCollectionViewCell.self,
                                 forCellWithReuseIdentifier: DateCollectionViewCell.reuseIdentifier)
    }
    
    private func loadAgendaCount() {
        if let allAgenda = Agenda.fetchAllAgenda() {
            for agenda in allAgenda {
                if agendaCountHolder[Int(agenda.date)] == nil {
                   agendaCountHolder[Int(agenda.date)] = 1
                } else {
                    agendaCountHolder[Int(agenda.date)]! += 1
                }
            }
        }
    }
    
    private func emptyColumnsAt(startOfMonth month: Int) -> Int {
        return startWeekDayIndexes[month]
    }
    
    private func lastDay(forMonth month: Int) -> Int {
        return lastDays[month]
    }
    
    private func sectionHeight(forMonthIndex monthIndex: Int) -> CGFloat {
        var sectionHeight: CGFloat = 0
        let monthIndexPath = IndexPath(item: 0, section: monthIndex)
        let sectionTopY = collectionView?.layoutAttributesForItem(at: monthIndexPath)?.frame.origin.y
        var sectionBottomY: CGFloat?
        if monthIndex + 1 == monthsInAYear {
            sectionBottomY = collectionView!.contentSize.height
        } else {
            let nextMonthIndexPath = IndexPath(item: 0, section: monthIndex + 1)
            sectionBottomY = collectionView?.layoutAttributesForItem(at: nextMonthIndexPath)?.frame.origin.y
        }
        if let sectionTopY = sectionTopY, let sectionBottomY = sectionBottomY {
            sectionHeight = sectionBottomY - sectionTopY
        }
        return sectionHeight
    }
    
    //Updates the navigation bar title to the current showing month name
    //updates month visible rect window
    private func initiateParentViewUpdates() {
        guard let parentVC = parent as? MonthAgendaParentViewController else {
            return
        }
        //calculate height of the calendar and animate the calendar window as per to fit the calendar
        let height = sectionHeight(forMonthIndex: currentShowingMonthIndex)
        parentVC.updateView(forCurrentShowingMonthIndex: currentShowingMonthIndex,
                            calendarHeight: height)
    }
    
    private func dateValue(forIndexPath indexPath: IndexPath) -> Int {
        let emptyColomns = emptyColumnsAt(startOfMonth: indexPath.section)
        return (indexPath.row - emptyColomns) + 1
    }
    
    private func deselectCurrentSelectedCell() {
        if let currentSelectedCellIndexPath = currentSelectedCellIndexPath,
            let currentSelectedCell = collectionView?.cellForItem(at: currentSelectedCellIndexPath),
            let cell = currentSelectedCell as? DateCollectionViewCell {
            cell.set(selected: false)
        }
        currentSelectedCellIndexPath = nil
    }
    
    private func selectCellAtIndexPath(indexPath: IndexPath) {
        if let newSelectedCell = collectionView?.cellForItem(at: indexPath),
            let cell = newSelectedCell as? DateCollectionViewCell {
            cell.set(selected: true)
            (parent as? MonthAgendaParentViewController)?.updateAgendaListItems(forDate: dateValue(forIndexPath: indexPath))
        }
        currentSelectedCellIndexPath = indexPath
    }
    
    private func performViewCleanupOnMonthChange() {
        DispatchQueue.main.async { [unowned self] in
            self.deselectCurrentSelectedCell()
        }
        //clear agenda list
        (parent as? MonthAgendaParentViewController)?.updateAgendaListItems(forDate: 0)
    }
    
    //MARK: Public method
    //month ranges from 1-12, representing Jan to Dec
    func scroll(toMonth month: Int, animated: Bool) {
        let monthIndex = month - 1
        if monthIndex == currentShowingMonthIndex {
            //Already showing that month, reload collection view to highlight the current date
            currentSelectedCellIndexPath = nil
            collectionView?.reloadData()
        } else {
            //scroll to current month
            currentShowingMonthIndex = monthIndex
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: currentShowingMonthIndex),
                                         at: .top,
                                         animated: animated)
        }
        performViewCleanupOnMonthChange()
    }
    
    //MARK: IBActions
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        var index: Int = 0
        switch sender.direction {
        case .up:
            index = min(currentShowingMonthIndex + 1, monthsInAYear - 1)
        case .down:
            index = max(0, currentShowingMonthIndex - 1)
        default:
            break
        }
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: index),
                                     at: .top,
                                     animated: true)
        currentShowingMonthIndex = index
        performViewCleanupOnMonthChange()
    }
}

extension MonthListCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthsInAYear
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        if section < startWeekDayIndexes.count, section < lastDays.count {
            numberOfItems = emptyColumnsAt(startOfMonth: section) + lastDays[section]
        }
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(Constants.CalendarLayout.daysInAWeek)
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //If no selected cell and date = currentDate, highlight the cell
        let date = dateValue(forIndexPath: indexPath)
        if currentSelectedCellIndexPath == nil {
            let completeDate = Calendar.current.date(from: DateComponents(year: selectedMonth!.year,
                                                                          month: currentShowingMonthIndex + 1,
                                                                          day: date))
            if completeDate == formattedDate {
                DispatchQueue.main.async(execute: { [unowned self] in
                    self.selectCellAtIndexPath(indexPath: indexPath)
                })
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell!
        //show empty cells if any empty days before the 1st of that month
        let emptyColomns = emptyColumnsAt(startOfMonth: indexPath.section)
        if indexPath.row < emptyColomns {
            let emptyCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCollectionViewCell.reuseIdentifier,
                                                   for: indexPath)
            cell = emptyCell
        } else {
            guard let dateDisplayCell =
                collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.reuseIdentifier,
                                                   for: indexPath) as? DateCollectionViewCell
                else {
                    fatalError("Cell not loaded")
            }
            let date = dateValue(forIndexPath: indexPath)
            let agendaCount = agendaCountHolder[date] == nil ? 0 : agendaCountHolder[date]!
            dateDisplayCell.set(dateString: "\(date)", numberOfAgendaForToday: agendaCount)
            cell = dateDisplayCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //unselect the previous selected cell
        deselectCurrentSelectedCell()
        //mark cell as selected, update the agenda list
        selectCellAtIndexPath(indexPath: indexPath)
    }
}
