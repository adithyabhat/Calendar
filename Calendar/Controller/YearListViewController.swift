//
//  YeaListTableViewController.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 28/02/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

class YearListViewController: UIViewController {
    private var currentDisplayYearIndexValueHolder: Int?
    private var currentDisplayYearIndex: Int? {
        get {
            return currentDisplayYearIndexValueHolder
        }
        set {
            currentDisplayYearIndexValueHolder = newValue
            //update navigationbar title with the current displaying year
            let index = ((currentDisplayYearIndexValueHolder == nil) ? 0 : currentDisplayYearIndexValueHolder!)
            updateTitle(forCurrentIndex: index)
        }
    }
    private var isFirstTime: Bool {
        return currentDisplayYearIndex == nil
    }
    private var currentYearIndex: Int!
    private var currentSelectedMonth: Int?
    private var weatherForecastFetcher: WeatherForecastFetcher?
    //This list will act as the datasource for the tableview
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherInfoFetchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tempDisplayLabel: UILabel!
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initateWeatherInfoFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        //scroll to current year
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.isFirstTime {
                let currentYear = Calendar.current.component(.year, from: Date())
                self.currentDisplayYearIndex = currentYear - Constants.CalendarRange.startYear
                self.currentYearIndex = self.currentDisplayYearIndex
                let indexPath = IndexPath(row: self.currentDisplayYearIndex!, section: 0)
                self.tableView.scrollRectToVisible(self.tableView.rectForRow(at: indexPath),
                                                   animated: false)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //Set updated tableview height as the row height
        tableView.estimatedRowHeight = tableView.bounds.size.height
        tableView.rowHeight = tableView.bounds.size.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.showMonthExpandedSegueIdentifier,
            let navController = segue.destination as? UINavigationController,
            let destinationController = navController.viewControllers.first as? MonthAgendaParentViewController {
            //set selected month and year info for the controller
            let currentYear = Constants.CalendarRange.startYear +
                (currentDisplayYearIndex == nil ? 0 : currentDisplayYearIndex!)
            destinationController.selectedMonth = SelectedMonth(month: currentSelectedMonth!, year: currentYear)
        }
    }
    
    //MARK: Private helper methods
    private func setUpUI() {
        //TableView setup
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "YearTableViewCell", bundle: nil),
                           forCellReuseIdentifier: YearTableViewCell.reuseIdentifier)
        //Left bar button
        //Load custom view for left bar button item
        guard let leftBarButtonView = Bundle.main.loadNibNamed("TempDisplayLeftTopBarButtonView",
                                                               owner: self,
                                                               options: nil)?.first as? UIView else {
            return
        }
        self.weatherInfoFetchActivityIndicator.isHidden = true
        self.tempDisplayLabel.isHidden = true
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func initateWeatherInfoFetch() {
        weatherForecastFetcher = WeatherForecastFetcher.init(delegate: self)
        weatherForecastFetcher?.fetchCurrentWeatherInfo()
    }
    
    private func updateTitle(forCurrentIndex index: Int) {
        let currentDisplayingYear = Constants.CalendarRange.startYear + index
        self.title = "\(currentDisplayingYear)"
    }
    
    private func currentShowingIndex() -> Int {
        return Int(tableView.contentOffset.y / tableView.frame.size.height)
    }
    
    //MARK: IBOutlets
    @IBAction func showCurrentYear(_ sender: Any) {
        tableView.scrollToRow(at: IndexPath(row: currentYearIndex, section: 0),
                              at: .middle,
                              animated: true)
    }
}

extension YearListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.CalendarRange.endYear - Constants.CalendarRange.startYear
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Configure cell to display the year's calendar
        if let yearTableViewCell = cell as? YearTableViewCell {
            let year = Constants.CalendarRange.startYear + indexPath.row
            yearTableViewCell.configureCell(forYear: year, withDelegate: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YearTableViewCell.reuseIdentifier,
                                                 for: indexPath)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentDisplayYearIndex = currentShowingIndex()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentDisplayYearIndex = currentShowingIndex()
    }
}

extension YearListViewController: ThumbnailMonthViewDelegate {
    func selected(month: Int) {
        currentSelectedMonth = month
        //Animate transition to next view
        UIView.transition(with: self.navigationController!.view,
                          duration: 0.8,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            //transition to month and agenda detail screen
                            self.performSegue(withIdentifier: Constants.SegueIdentifier.showMonthExpandedSegueIdentifier,
                                         sender: self)
        }, completion: nil)
    }
}

extension YearListViewController: WeatherForecastFetcherDelegate {
    func initiatedFetchingWeatherInfo() {
        weatherInfoFetchActivityIndicator.isHidden = false
    }
    
    func currentTemperature(temperature: CGFloat) {
        weatherInfoFetchActivityIndicator.isHidden = true
        tempDisplayLabel.isHidden = false
        tempDisplayLabel.text = String(format: "%.1f", arguments: [temperature])+"°C"
    }
    
    func didFailFetchingWeatherInfo() {
        weatherInfoFetchActivityIndicator.isHidden = true
    }
}
