//
//  LiveViewController.swift
//  ElderTales
//
//  Created by student on 25/04/24.
//

import UIKit
import SwiftUI

class LiveViewController: UIViewController, UITableViewDataSource{
    
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

        
        // Configure the cell with data from the post
        cell.profilePhotoUIImage.image = UIImage(named: "otherPhoto")
        cell.username.text = live.postedBy.name
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto")
        
        
        
        return cell
        
    }
    
    @IBOutlet weak var liveTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addLiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateDummyData()
        super.viewDidLoad()
       liveTableView.dataSource = self
        addLiveButton.layer.borderWidth = 2
        addLiveButton.layer.cornerRadius = 10
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        selectedLives = []
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
