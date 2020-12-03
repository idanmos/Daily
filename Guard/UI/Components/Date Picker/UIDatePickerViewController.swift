//
//  UIDatePickerViewController.swift
//  Daily
//
//  Created by Idan Moshe on 28/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

protocol UIDatePickerViewControllerDelegate: class {
    func datePickerController(_ picker: UIDatePickerViewController, didFinishPickingDate date: Date)
    func datePickerControllerDidCancel(_ picker: UIDatePickerViewController)
}

class UIDatePickerViewController: UIViewController {
    
    weak var delegate: UIDatePickerViewControllerDelegate?
    
    var selectedDate: Date?
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.maximumDate = Date()
        
        self.datePicker.locale = .current
        self.datePicker.calendar = .current
        self.datePicker.timeZone = .current
        
        self.datePicker.datePickerMode = .date
        
        if let selectedDate = self.selectedDate {
            self.datePicker.date = selectedDate
        } else {
            self.datePicker.date = Date()
        }
    }

    @IBAction func onSave(_ sender: Any) {
        self.delegate?.datePickerController(self, didFinishPickingDate: self.datePicker.date)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.delegate?.datePickerControllerDidCancel(self)
    }
    
}
