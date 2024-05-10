//  LiveViewController.swift
//  ElderTales
//
//  Created by student on 25/04/24.

import UIKit
import SwiftUI
import EventKit

class LiveViewController: UIViewController, UITableViewDataSource, LiveOtherViewCellDelegate{
    
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
        var identifier = live.isOngoing ? "liveOtherLive" : "liveOther"
        switch(segmentedControl.selectedSegmentIndex){
        case 0:
            identifier = live.isOngoing ? "liveOtherLive" : "liveOther"
        
        case 1:
            identifier = live.isOngoing ? "liveMyLive" : "liveMy"
        default:
            identifier = "liveOtherLive"
        }
        let cell = liveTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LiveOtherTableViewCell

        
        cell.profilePhotoUIImage.image = UIImage(named: "otherPhoto")
        cell.username.text = live.postedBy.name
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto")
        cell.uuid = live.id
        cell.delegate = self
        
        return cell
        
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
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event added to calendar successfully.")
        } catch let error as NSError {
            print("Failed to save event: \(error)")
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



}
