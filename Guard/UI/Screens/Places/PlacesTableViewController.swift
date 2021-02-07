//
//  PlacesTableViewController.swift
//  Daily
//
//  Created by Idan Moshe on 28/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class PlacesTableViewController: BaseTableViewController {
    
    private let viewModel = PlacesViewModel()
    
    private lazy var datePickerController: UIDatePickerViewController = {
        let picker = UIDatePickerViewController(nibName: String(describing: UIDatePickerViewController.self), bundle: nil)
        picker.modalPresentationStyle = .overCurrentContext
        picker.delegate = self
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)
        
        self.tableView.register(UINib(nibName: LocationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: LocationTableViewCell.identifier)
                
        self.viewModel.registerStartDateObserver { [weak self] (title: String) in
            guard let self = self else { return }
            self.navigationItem.title = title
        }
        
        self.loadAndRefreshData()
    }
    
    // MARK: - General methods
    
    private func loadAndRefreshData() {
        self.viewModel.fetchData()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier, for: indexPath) as! LocationTableViewCell
        
        if let visit = self.viewModel.places[indexPath.row] as? Visit {
            cell.configure(visit)
        } else if let location = self.viewModel.places[indexPath.row] as? Location {
            cell.configure(location)
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}

// MARK: - Actions

extension PlacesTableViewController {
    
    @IBAction func onPressCalendar(_ sender: Any) {
        self.present(self.datePickerController, animated: true, completion: nil)
    }
    
}

// MARK: - DatePickerViewControllerDelegate

extension PlacesTableViewController: UIDatePickerViewControllerDelegate {
    
    func datePickerController(_ picker: UIDatePickerViewController, didFinishPickingDate date: Date) {
        picker.dismiss(animated: true, completion: nil)
        self.viewModel.startDate = date
        self.loadAndRefreshData()
    }
    
    func datePickerControllerDidCancel(_ picker: UIDatePickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
