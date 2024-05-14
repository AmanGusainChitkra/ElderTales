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
    
    var onDismiss: (() -> Void)?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let adjustmentHeight = keyboardSize.height - (view.frame.height - titleTextField.frame.origin.y - titleTextField.frame.height)
                if adjustmentHeight > 0 {
                    view.frame.origin.y -= adjustmentHeight
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        onDismiss?()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    
    @IBAction func didTapSave(_ sender: UIButton) {
        scheduleLiveButtonTapped(sender)
    }
    
    @IBAction func scheduleLiveButtonTapped(_ sender: UIButton) {
        // Create the live session
        guard let title = titleTextField.text else {return}
        let newLive = Live(postedBy: dataController.currentUser!.id, postedOn: Date(), beginsOn: datePicker.date, title: title)
        
        // Add to the global lives array
        dataController.addNewLive(live: newLive)
        // Optionally, show confirmation to user
        showConfirmationAndPop()
    }

    private func showConfirmationAndPop() {
        let alert = UIAlertController(title: "Success", message: "Your live session has been scheduled.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // Pop the view controller
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}
