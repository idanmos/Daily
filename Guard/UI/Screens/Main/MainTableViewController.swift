//
//  MainTableViewController.swift
//  Guard
//
//  Created by Idan Moshe on 05/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import CoreLocation.CLLocation
import FirebaseAnalytics
import GoogleMobileAds

class MainTableViewController: BaseTableViewController {
    
    lazy var sectionHederView: ActivitySectionHeaderView = {
        let headerView = ActivitySectionHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 28))
        return headerView
    }()
    
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
                
        var title: String = ""
        if Calendar.current.isDateInToday(PreferenceManager.currentSession.startDate) {
            title = Localization.today.preferredLocalization
        } else if Calendar.current.isDateInYesterday(PreferenceManager.currentSession.startDate) {
            title = Localization.yesterday.preferredLocalization
        } else {
            title = DateFormatter.dateOnly.string(from: PreferenceManager.currentSession.startDate)
        }
        
        self.navigationItem.title = title
        
        self.tableView.register(UINib(nibName: ActivityTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ActivityTableViewCell.identifier)
        self.tableView.register(UINib(nibName: LocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.identifier)
        self.tableView.register(UINib(nibName: SleepAnalysisTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SleepAnalysisTableViewCell.identifier)
        self.tableView.register(UINib(nibName: WorkoutTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: WorkoutTableViewCell.identifier)
        
        PreferenceManager.currentSession.fetchData(completionHandler: { [weak self] in            
            guard let self = self else { return }
            self.tableView.reloadData()
        })
        
        self.interstitial = GADInterstitial(adUnitID: Application.GoogleAdMob.bannerId)
        let request = GADRequest()
        self.interstitial.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = PreferenceManager.currentSession.recentActivities.count
        return rows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let activity = PreferenceManager.currentSession.recentActivities[indexPath.row] as? Activity {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as! ActivityTableViewCell
            cell.updateWithActivity(activity)
            return cell
        } else if let activity = PreferenceManager.currentSession.recentActivities[indexPath.row] as? Visit {            
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
            cell.configure(activity)
            return cell
        } else if let activity = PreferenceManager.currentSession.recentActivities[indexPath.row] as? SleepData {
            let cell = tableView.dequeueReusableCell(withIdentifier: SleepAnalysisTableViewCell.identifier, for: indexPath) as! SleepAnalysisTableViewCell
            cell.updateWithActivity(activity)
            return cell
        } else if let activity = PreferenceManager.currentSession.recentActivities[indexPath.row] as? Workout {
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
        self.sectionHederView.configureWithStartDate(PreferenceManager.currentSession.startDate)
        return self.sectionHederView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
   
    // MARK: - Actions
    
    @IBAction func onPressCalendar(_ sender: Any) {
//        var pickerController: CalendarPickerViewController!
//        pickerController = CalendarPickerViewController(baseDate: PreferenceManager.currentSession.startDate, selectedDateChanged: { [weak self] date in
//            guard let self = self else { return }
//            
//            PreferenceManager.currentSession.startDate = date
//            
//            var title: String = ""
//            if Calendar.current.isDateInToday(PreferenceManager.currentSession.startDate) {
//                title = Localization.today.preferredLocalization
//            } else if Calendar.current.isDateInYesterday(PreferenceManager.currentSession.startDate) {
//                title = Localization.yesterday.preferredLocalization
//            } else {
//                title = DateFormatter.dateOnly.string(from: PreferenceManager.currentSession.startDate)
//            }
//            self.title = title
//            
//            
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                pickerController.dismiss(animated: true, completion: {
//                    PreferenceManager.currentSession.fetchData(completionHandler: {
//                        self.tableView.reloadData()
//                    })
//                })
//            }
//        })
//
//        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func onPressMap(_ sender: Any) {
    }
    
}
