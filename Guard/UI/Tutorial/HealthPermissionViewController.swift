//
//  HealthPermissionViewController.swift
//  Guard
//
//  Created by Idan Moshe on 13/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class HealthPermissionViewController: BaseCoordinatorViewController {
        
    @IBOutlet weak var requestPermissionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)
        
        self.requestPermissionButton.makeRoundButton()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onPressRequestPermissions(_ sender: Any) {
        PreferenceManager.isTutorialCompleted = true
        PreferenceManager.isHealthEnabled = true
        PreferenceManager.isActivityEnabled = true
        PreferenceManager.isVisitsEnabled = true
        
        HealthProfileDataStore.authorizeHealthKit { (granted: Bool, error: Error?) in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let initialViewController: UIViewController = mainStoryboard.instantiateInitialViewController() {
                if let window: UIWindow = AppDelegate.sharedDelegate().window {
                    window.rootViewController = initialViewController
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
}
