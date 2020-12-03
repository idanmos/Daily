//
//  ActivitiesTableViewController.swift
//  Daily
//
//  Created by Idan Moshe on 29/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class ActivitiesTableViewController: BaseTableViewController {
    
    private let activitiesViewModel = ActivitiesViewModel()
    
    private lazy var sectionHederView: ActivitySectionHeaderView = {
        let headerView = ActivitySectionHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 28))
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)
        
        self.tableView.register(UINib(nibName: ActivityTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ActivityTableViewCell.identifier)
        self.tableView.register(UINib(nibName: SleepAnalysisTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SleepAnalysisTableViewCell.identifier)
        self.tableView.register(UINib(nibName: WorkoutTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        
        self.activitiesViewModel.fetchData { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activitiesViewModel.activities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let activity = self.activitiesViewModel.activities[indexPath.row] as? Activity {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as! ActivityTableViewCell
            cell.updateWithActivity(activity)
            return cell
        } else if let activity = self.activitiesViewModel.activities[indexPath.row] as? SleepData {
            let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisTableViewCell.identifier, for: indexPath) as! SleepAnalysisTableViewCell
            cell.updateWithActivity(activity)
            return cell
        } else if let activity = self.activitiesViewModel.activities[indexPath.row] as? Workout {
            let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutTableViewCell.identifier, for: indexPath) as! WorkoutTableViewCell
            cell.updateWithActivity(activity)
            return cell
        }
        
        return UITableViewCell(frame: .zero)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.sectionHederView.configureWithStartDate(self.activitiesViewModel.startDate)
        return self.sectionHederView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
