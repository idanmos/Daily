//
//  SettingsTableViewController.swift
//  Guard
//
//  Created by Idan Moshe on 12/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import GoogleMobileAds

class SettingsTableViewController: UITableViewController {
    
    // Permissions
    @IBOutlet weak var motionAuthrizationLabel: UILabel!
    @IBOutlet weak var locationAuthrizationLabel: UILabel!
    @IBOutlet weak var healthAuthorizationLabel: UILabel!
    
    // Show on feed
    @IBOutlet weak var locationVisitsLabal: UILabel!
    @IBOutlet weak var motionActivityLabel: UILabel!
    @IBOutlet weak var workoutsLabel: UILabel!
    @IBOutlet weak var locationVisitsSwitch: UISwitch!
    @IBOutlet weak var motionActivitySwitch: UISwitch!
    @IBOutlet weak var workoutsSwitch: UISwitch!
    
    private var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)

        DispatchQueue.main.async {
            self.changePermissionButtonState()
            self.changeShowOnFeedSwitchState()
        }
        
        self.motionAuthrizationLabel.superview!.makeRoundButton()
        self.locationAuthrizationLabel.superview!.makeRoundButton()
        self.healthAuthorizationLabel.superview!.makeRoundButton()
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] (note: Notification) in
            guard let self = self else { return }
            self.changePermissionButtonState()
            self.changeShowOnFeedSwitchState()
        }
        
        self.interstitial = GADInterstitial(adUnitID: Application.GoogleAdMob.bannerId)
        let request = GADRequest()
        self.interstitial.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 3
        }
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            self.goToSettings()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onPressLocationVisitsSwitch(_ sender: Any) {
        PreferenceManager.isVisitsEnabled = self.locationVisitsSwitch.isOn
    }
    
    @IBAction func onPressActivitySwitch(_ sender: Any) {
        PreferenceManager.isActivityEnabled = self.motionActivitySwitch.isOn
    }
    
    @IBAction func onPressWorkoutSwitch(_ sender: Any) {
        PreferenceManager.isHealthEnabled = self.workoutsSwitch.isOn
    }
    
    // MARK: - General Methods
    
    private func goToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                //
            })
        }
    }
    
    private func changePermissionButtonState() {
        // Motion
        if MotionManager.shared.isAuthorized {
            self.motionAuthrizationLabel.alpha = 0.5
            self.motionAuthrizationLabel.text = Localization.authorized.preferredLocalization
        } else {
            self.motionAuthrizationLabel.alpha = 1.0
            self.motionAuthrizationLabel.text = Localization.notAuthorized.preferredLocalization
        }
        
        
        // Locations
        let isLocationAuthorized: Bool = LocationController.isAuthorized().0
        let isLocationAuthorizedDescription = LocationController.isAuthorized().1
        
        if isLocationAuthorized {
            self.locationAuthrizationLabel.alpha = 0.5
            self.locationAuthrizationLabel.text = Localization.authorized.preferredLocalization
        } else {
            self.locationAuthrizationLabel.alpha = 1.0
            
            if isLocationAuthorizedDescription == "authorizedWhenInUse" {
                self.locationAuthrizationLabel.text = Localization.noBackgroundAuthorization.preferredLocalization
            } else {
                self.locationAuthrizationLabel.text = Localization.notAuthorized.preferredLocalization
            }
        }
        
        // Health
        HealthProfileDataStore.authorizeHealthKit { (granted: Bool, error: Error?) in
            if granted {
                self.healthAuthorizationLabel.alpha = 0.5
                self.healthAuthorizationLabel.text = Localization.authorized.preferredLocalization
            } else {
                self.healthAuthorizationLabel.alpha = 1.0
                self.healthAuthorizationLabel.text = Localization.notAuthorized.preferredLocalization
            }
        }
    }
    
    private func changeShowOnFeedSwitchState() {
        self.locationVisitsSwitch.isOn = PreferenceManager.isVisitsEnabled
        self.motionActivitySwitch.isOn = PreferenceManager.isActivityEnabled
        self.workoutsSwitch.isOn = PreferenceManager.isHealthEnabled
    }
    
}
