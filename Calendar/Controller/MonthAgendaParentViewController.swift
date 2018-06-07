//
//  MonthAgendaParentViewController.swift
//  Calendar
//
//  Created by Bhat, Adithya H on 05/03/18.
//  Copyright © 2018 SAP Labs, Bengaluru. All rights reserved.
//

import UIKit

struct SelectedMonth {
    var month: Int
    var year: Int
}

class MonthAgendaParentViewController: UIViewController {
    var selectedMonth: SelectedMonth?
    var shadowGradientLayer: CAGradientLayer!
    weak var monthListViewController: MonthListCollectionViewController!
    weak var agendaListViewController: AgendaTableViewController!
    @IBOutlet weak var calendarViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    //MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        identifyChildViewControllers()
        monthListViewController.selectedMonth = selectedMonth
        setUpUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        shadowGradientLayer.frame = shadowView.bounds
    }
    
    //MARK: Private helper methods
    private func identifyChildViewControllers() {
        for childViewController in self.childViewControllers {
            if let viewController = childViewController as? MonthListCollectionViewController {
                monthListViewController = viewController
            } else if let viewController = childViewController as? AgendaTableViewController {
                agendaListViewController = viewController
            }
        }
        if monthListViewController == nil, agendaListViewController == nil {
            fatalError("Not supposed to happen! Check")
        }
    }
    
    func addShadow() {
        shadowGradientLayer = CAGradientLayer()
        shadowGradientLayer.colors = [UIColor.black.withAlphaComponent(0.15).cgColor,
                                      UIColor.clear.cgColor]
        shadowView.layer.addSublayer(shadowGradientLayer)
    }
    
    func setUpUI() {
        addShadow()

        //configure bar button items
        leftBarButtonItem.title = "\(selectedMonth!.year)"
        leftBarButtonItem.target = self
        leftBarButtonItem.action = #selector(dismissMonthView)
        rightBarButtonItem.title = "Current"
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(showCurrentMonthCalendar)
    }
    
    //MARK: Public method
    func updateView(forCurrentShowingMonthIndex monthIndex: Int, calendarHeight: CGFloat) {
        self.title = Calendar.monthName(forMonth: monthIndex + 1, format: .full)
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.calendarViewHeightConstraint.constant = calendarHeight
            self.view.layoutIfNeeded()
        }
    }
    
    func updateAgendaListItems(forDate date: Int) {
        agendaListViewController.update(forDate: date)
    }
    
    //MARK: Action method
    @objc func showCurrentMonthCalendar() {
        let month = Calendar.current.component(.month, from: Date())
        UIView.transition(with: monthListViewController.view,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [unowned self] in
                            self.monthListViewController.scroll(toMonth: month, animated: false)
        },
                          completion: nil)
    }
    
    @objc func dismissMonthView() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
