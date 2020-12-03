//
//  BaseNibViewController.swift
//  Guard
//
//  Created by Idan Moshe on 24/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class BaseNibViewController: UIViewController {
    
    override func loadView() {
        self.view = viewFromNib()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
