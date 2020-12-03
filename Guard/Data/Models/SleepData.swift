//
//  SleepData.swift
//  Guard
//
//  Created by Idan Moshe on 06/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class SleepData {
    
    var startDate: Date!
    var endDate: Date!
    var isInBed: Bool = false
    var isAsleep: Bool = false
    var isAwake: Bool = false
    
    var avtivityDescription: String {
        if self.isInBed {
            return "In bed"
        } else if self.isAsleep {
            return "Sleep"
        } else if self.isAwake {
            return "Awake"
        } else {
            return ""
        }
    }
    
}
