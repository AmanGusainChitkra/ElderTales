//  LiveViewController.swift
//  ElderTales
//
//  Created by student on 25/04/24.

import UIKit
import SwiftUI
import EventKit

class LiveViewController: UIViewController, UITableViewDataSource, LiveOtherViewCellDelegate{
    func didTapProfilePhoto(for cell: LiveOtherTableViewCell) {
        guard let live = dataController.fetchLive(liveId: cell.uuid) else {return}
        if(live.postedBy == dataController.currentUser?.id) {
            self.tabBarController?.selectedIndex = 3
            return
        }
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "viewProfileController") as? ViewProfileOtherViewController{
            destinationVC.userId = live.postedBy
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func didTapDeleteLiveButton(for cell: LiveOtherTableViewCell) {
        let alert = UIAlertController(title: "Delete Live", message: "Are you sure you want to delete this live session?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            dataController.deleteLive(liveId: cell.uuid)
            // Optionally, update UI or pop viewController if needed
            self?.liveTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func didTapJoinLiveOtherButton(for cell: LiveOtherTableViewCell) {
        //push destination controller and set destination.liveId to cell.uuid
        if let liveOngoingViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingOtherViewController") as? LiveOngoingViewController {
            liveOngoingViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(liveOngoingViewController, animated: true)
        }
    }
    
    func didTapJoinLiveMyButton(for cell: LiveOtherTableViewCell) {
        
        if let liveOngoingMyViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingMyViewController") as? MyLiveOngoingViewController {
            liveOngoingMyViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(liveOngoingMyViewController, animated: true)
        }
    }
    
    
    func didTapJoinLiveButton(for cell: LiveOtherTableViewCell) {
        
        print("Join Live tapped")
        if let joinLiveViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingOtherViewController") as? MyLiveOngoingViewController {
            joinLiveViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(joinLiveViewController, animated: true)
        }
    }
    
    
    var selectedLives: [Live] {
        get {
            // Determine which posts to return based on the segmented control's selection.
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let allLives = dataController.fetchAllLives()
                return allLives.filter { $0.postedBy != dataController.currentUser?.id && !$0.isFinished}
                
            case 1:
                return dataController.fetchLives(postedBy: dataController.currentUser!.id)
            default:
                return []
            }
        }
        set {
            // Reload the table view whenever the selection changes.
            liveTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedLives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let live = selectedLives[indexPath.row]
        var identifier = live.isOngoing ? "liveOtherLiveCell" : "liveOtherCell"
        switch(segmentedControl.selectedSegmentIndex) {
        case 0:
            identifier = live.isOngoing ? "liveOtherLiveCell" : "liveOtherCell"
        case 1:
            identifier = live.isOngoing ? "liveMyLiveCell" : "liveMyLiveCell"
            if(live.isFinished){identifier = "liveFinishedCell"}
            
        default:
            identifier = "liveOtherLiveCell"
        }
        let cell = liveTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LiveOtherTableViewCell

        // Format and set the date of the live event
        cell.dateOfLive.text = formatDate(live.beginsOn)
        cell.timeOfLive.text = formatTime(live.beginsOn)

         // Assuming you have a default or placeholder image
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto") // Placeholder or default image
        
        if let user = dataController.fetchUser(userId: live.postedBy){
            cell.username.text = user.name
            cell.profilePhotoUIImage.image = dataController.fetchImage(imagePath: user.image) ?? UIImage(systemName: "person.circle.fill")
        }
        cell.uuid = live.id
        cell.delegate = self
        
        if(live.isFinished){
            cell.joinLiveButton.isEnabled = false
        }
        return cell
    }

    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM" // e.g., 2 March
        return dateFormatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // e.g., 6:00 PM
        return timeFormatter.string(from: date)
    }

    
    @IBOutlet weak var liveTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    @IBOutlet weak var addLiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
       liveTableView.dataSource = self
//        addLiveButton.layer.borderWidth = 2
//        addLiveButton.layer.cornerRadius = 10
        registerCellsToTable()
    }
    
    func registerCellsToTable(){
        let cells = ["liveOtherCell", "liveMyLiveCell", "liveMyCell","liveOtherLiveCell","liveFinishedCell"]
        for nibName in cells{
            let nib = UINib(nibName: nibName, bundle: nil)
            liveTableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        selectedLives = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        liveTableView.reloadData()
    }
    
    func didTapAddEventButton(for cell: LiveOtherTableViewCell) {
        guard let live = dataController.fetchLive(liveId: cell.uuid) else {
            return
        }
        
        requestAccessToCalendar { [weak self] granted in
            guard granted, let strongSelf = self else {
                print("Access to calendar denied.")
                return
            }
            cell.addEventButton.setTitle("Event Added", for: .normal)
            
            cell.addEventButton.backgroundColor = .clear
            strongSelf.addEventToCalendar(live: live)
        }
    }

    func addEventToCalendar(live: Live) {
        let event = EKEvent(eventStore: eventStore)
        event.title = live.title
        event.startDate = live.beginsOn
        event.endDate = live.beginsOn.addingTimeInterval(2 * 60 * 60) // Assume 2 hours duration
        event.calendar = eventStore.defaultCalendarForNewEvents
        if let user = dataController.fetchUser(userId: live.postedBy){
            event.notes = "Live event hosted by \(user.name)"
        }
        
        
        // Add an alarm to the event to remind the user
        let alarm = EKAlarm(relativeOffset: -1800)  // 1 hour before the event
        event.addAlarm(alarm)

        do {
            try eventStore.save(event, span: .thisEvent)
            showAlertWith(title: "Success", message: "Event added to calendar successfully, with a reminder set for 1 hour before the event.")
        } catch let error as NSError {
            showAlertWith(title: "Error", message: "Failed to save event: \(error.localizedDescription)")
        }
    }

    // Utility function to show alerts
    func showAlertWith(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true, completion: nil)
        }
    }


    
    let eventStore = EKEventStore()

    func requestAccessToCalendar(completion: @escaping (Bool) -> Void) {
        eventStore.requestWriteOnlyAccessToEvents { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting event access: \(error)")
                }
                completion(granted)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "joinLiveSegue" {
//                if let destinationVC = segue.destination as? LiveOngoingViewController,
//                   let cell = sender as? LiveOtherTableViewCell{
//                   let uuid = cell.uuid
//                    print("UUID: \(uuid)")
//                    destinationVC.liveId = uuid
//                }
//            }
//        if segue.identifier == "viewProfileSegue"{
//            if let destinationVC = segue.destination as? ViewProfileOtherViewController,
//               let cell = sender as? HomePostTableViewCell,
//               let uuid = cell.uuid{
//                let postedBy = posts.first(where: {$0.id == uuid})?.postedBy
//                destinationVC.userId = postedBy?.id ?? ""
//            }
//        }
    }

    @IBAction func didTapPlusIcon(_ sender: Any) {
        if let newNavigationController = storyboard?.instantiateViewController(withIdentifier: "scheduleNewLiveNavigation") as? UINavigationController {
            newNavigationController.modalPresentationStyle = .formSheet
            if let scheduleLiveViewController = newNavigationController.viewControllers.first as? ScheduleNewLiveViewController {
                scheduleLiveViewController.onDismiss = { [weak self] in self?.liveTableView.reloadData()}
                present(newNavigationController, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func didTapGoLive(_ sender: Any) {
        let alertController = UIAlertController(title: "Start Live Session", message: "Enter the title for your live session.", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Live Session Title"
        }
        
        let startAction = UIAlertAction(title: "Start Live", style: .default) { [weak self] _ in
            guard let self = self, let title = alertController.textFields?.first?.text, !title.isEmpty else {
                self?.presentAlert(title: "Error", message: "The title cannot be empty.")
                return
            }
            
            // Create a new live session
            let newLive = Live(postedBy: dataController.currentUser!.id, postedOn: Date(), beginsOn: Date(), title: title, isOngoing: true)
            dataController.addNewLive(live: newLive)
            
            // Navigate to the ongoing live session page
            if let liveOngoingMyViewController = self.storyboard?.instantiateViewController(withIdentifier: "liveOngoingMyViewController") as? MyLiveOngoingViewController {
                liveOngoingMyViewController.liveId = newLive.id
                self.navigationController?.pushViewController(liveOngoingMyViewController, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(startAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    

}
