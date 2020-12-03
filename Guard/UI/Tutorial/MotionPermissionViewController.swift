//
//  MotionPermissionViewController.swift
//  Guard
//
//  Created by Idan Moshe on 13/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class MotionPermissionViewController: BaseCoordinatorViewController {
    
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
        MotionManager.shared.queryForRecentActivityData(startDate: Date(timeIntervalSinceNow: -60), endDate: Date()) { (activities: [Activity]) in
            debugPrint(activities)
        }
    }

}
