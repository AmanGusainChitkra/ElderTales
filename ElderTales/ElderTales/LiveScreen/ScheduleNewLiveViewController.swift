//
//  ScheduleNewLiveViewController.swift
//  ElderTales
//
//  Created by student on 09/05/24.
//

import UIKit

class ScheduleNewLiveViewController: UIViewController {
    
    
//    @IBOutlet weak var datePicker: UIDatePicker!
//    
//    @IBOutlet weak var startTiime: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTime: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set minimum date to today
        datePicker.minimumDate = Date()
        
        // Set date picker mode to date and time
        datePicker.datePickerMode = .dateAndTime
        
        // Optional: Set locale to user's current locale
        datePicker.locale = Locale.current
        
        // Optional: Set date picker to 24-hour time format
        datePicker.locale = Locale(identifier: "en_US_POSIX")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        
        
        
        if let selectedDate = UserDefaults.standard.string(forKey: "selectedDate") {
            startTime.text = "Selected Date: \(selectedDate)"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
        //
        //        @objc func dateChanged(_ datePicker: UIDatePicker) {
        //            let dateFormatter = DateFormatter()
        //            dateFormatter.dateStyle = .medium
        //            dateFormatter.timeStyle = .none
        //
        //            let selectedDate = dateFormatter.string(from: datePicker.date)
        //            print("Selected date: \(selectedDate)")
        //        }
        
    
        
        
        func datePickerChanged(_ sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let selectedDate = dateFormatter.string(from: sender.date)
            UserDefaults.standard.set(selectedDate, forKey: "selectedDate")
            startTime.text = selectedDate
        }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    @IBAction func scheduleLiveButtonTapped(_ sender: UIButton) {
        // Create the live session
        let newLive = Live(postedBy: currentUser!, postedOn: Date(), beginsOn: datePicker.date, title: "Live Session")
        
        // Add to the global lives array
        lives.append(newLive)
        
        // Optionally, show confirmation to user
        showConfirmationAndPop()
    }

    private func showConfirmationAndPop() {
        let alert = UIAlertController(title: "Success", message: "Your live session has been scheduled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // Pop the view controller
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }


}
