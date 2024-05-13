//  LiveViewController.swift
//  ElderTales
//
//  Created by student on 25/04/24.

import UIKit
import SwiftUI
import EventKit

class LiveViewController: UIViewController, UITableViewDataSource, LiveOtherViewCellDelegate{
    func didTapJoinLiveOtherButton(for cell: LiveOtherTableViewCell) {
        //push destination controller and set destination.liveId to cell.uuid
        if let liveOngoingViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingOtherViewController") as? LiveOngoingViewController {
            liveOngoingViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(liveOngoingViewController, animated: true)
        }
    }
    
    func didTapJoinLiveMyButton(for cell: LiveOtherTableViewCell) {

        if let liveOngoingMyViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingOtherViewController") as? MyLiveOngoingViewController {
            liveOngoingMyViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(liveOngoingMyViewController, animated: true)
        }
    }
    
    
    func didTapJoinLiveButton(for cell: LiveOtherTableViewCell) {
        performSegue(withIdentifier: "joinLiveSegue", sender: cell)
    }
    
    
    var selectedLives: [Live] {
        get {
            // Determine which posts to return based on the segmented control's selection.
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return lives.filter { $0.postedBy.id != currentUser?.id}
            case 1:
                return lives.filter { $0.postedBy.id == currentUser?.id }
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
        default:
            identifier = "liveOtherLiveCell"
        }
        let cell = liveTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LiveOtherTableViewCell

        // Format and set the date of the live event
        cell.dateOfLive.text = formatDate(live.beginsOn)
        cell.timeOfLive.text = formatTime(live.beginsOn)

        cell.profilePhotoUIImage.image = UIImage(named: "otherPhoto") // Assuming you have a default or placeholder image
        cell.username.text = live.postedBy.name
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto") // Placeholder or default image
        cell.uuid = live.id
        cell.delegate = self
        
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

        generateDummyData()
        super.viewDidLoad()
       liveTableView.dataSource = self
//        addLiveButton.layer.borderWidth = 2
//        addLiveButton.layer.cornerRadius = 10
        registerCellsToTable()
    }
    
    func registerCellsToTable(){
        let cells = ["liveOtherCell", "liveMyLiveCell", "liveMyCell","liveOtherLiveCell"]
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
        guard let live = lives.first(where: {$0.id == cell.uuid}) else {
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
        event.notes = "Live event hosted by \(live.postedBy.name)"
        
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
        if segue.identifier == "joinLiveSegue" {
                if let destinationVC = segue.destination as? LiveOngoingViewController,
                   let cell = sender as? LiveOtherTableViewCell{
                   let uuid = cell.uuid
                    print("UUID: \(uuid)")
                    destinationVC.liveId = uuid
                }
            }
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
    

}
