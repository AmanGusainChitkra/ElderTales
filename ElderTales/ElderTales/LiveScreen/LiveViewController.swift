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
        let cell = liveTableView.dequeueReusableCell(withIdentifier: "liveOther", for: indexPath) as! LiveOtherTableViewCell

        let live = selectedLives[indexPath.row]
        
        // Configure the cell with data from the post
        cell.profilePhotoUIImage.image = UIImage(named: "otherPhoto")
        cell.username.text = live.postedBy.name
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto")
        
        
        
        return cell
        
    }
    
    @IBOutlet weak var liveTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateDummyData()
        super.viewDidLoad()
       liveTableView.dataSource = self
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
