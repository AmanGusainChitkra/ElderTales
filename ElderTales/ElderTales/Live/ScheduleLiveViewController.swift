//
//  ScheduleLiveViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit

class ScheduleLiveViewController: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var startTiime: UILabel!
    
    
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
            startTiime.text = "Selected Date: \(selectedDate)"
        }
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
            startTiime.text = selectedDate
        }
        
        
    }
    

