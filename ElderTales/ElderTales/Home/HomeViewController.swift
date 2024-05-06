//
//  HomeViewController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UITableViewDataSource, HomePostTableViewCellDelegate {
    
    var selectedPosts: [Post] {
        get {
            // Determine which posts to return based on the segmented control's selection.
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return posts
            case 1:
                return posts.filter { $0.hasVideo == true }
            case 2:
                return posts.filter { $0.hasVideo == false }
            default:
                return []
            }
        }
        set {
            // Reload the table view whenever the selection changes.
            homeTableView.reloadData()
        }
    }
    
    func didTapListenButton(for cell: HomePostTableViewCell) {
        performSegue(withIdentifier: "nowPlayingSegue", sender: cell)

    }
    
    func didTapSaveButton(for cell: HomePostTableViewCell) {
        let postIndex = posts.firstIndex(where: {$0.id == cell.uuid})!
        currentUser?.savedPosts.append(posts[postIndex])
        cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
    }
    
    func didTapLikeButton(for cell: HomePostTableViewCell) {
        if let uuid = cell.uuid {
            if let postIndex = posts.firstIndex(where: { $0.id == uuid }) {
                let isCurrentlyLiked = cell.likeButton.currentImage == UIImage(systemName: "heart.fill")
                // Toggle the like state based on the current image
                posts[postIndex].likePost(liked: !isCurrentlyLiked)
                currentUser?.likePost(post: posts[postIndex], liked: !isCurrentlyLiked)
                
                // Update the button's image and like count display
                let newImageName = isCurrentlyLiked ? "heart" : "heart.fill"
                cell.likeButton.setImage(UIImage(systemName: newImageName), for: .normal)
                cell.likeCount.text = "\(posts[postIndex].likes)"
                
            } else {
                print("Post with UUID: \(uuid) not found.")
            }
        }
    }

    
    func didTapShareButton(for cell: HomePostTableViewCell) {
        if let uuid = cell.uuid {
                let postLink = "https://eldertales.com/post/\(uuid)"
                sharePostLink(postLink)
            }
    }
    
    func didTapCommentButton(for cell: HomePostTableViewCell) {
        print("hello")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postHome", for: indexPath) as! HomePostTableViewCell

        let post = selectedPosts[indexPath.row]
        cell.uuid = post.id
        
        cell.profilePhotoUIImage.image = post.postedBy.image
        cell.usernameLabel.text = post.postedBy.name
        cell.storyTitleLabel.text = post.title
        cell.thumbnailUIImage.image = UIImage(named: "youngster")
        
        // Set the interaction buttons and counts
        var heartState = ""
        var saveState = ""
        if(currentUser!.likedPosts.contains(where: { $0.id == post.id})){
            heartState = "heart.fill"
        }
        else {heartState = "heart"}
            cell.likeButton.setImage(UIImage(systemName: heartState), for: .normal)
        
        if(currentUser!.savedPosts.contains(where: { $0.id == post.id})){
            saveState = "square.and.arrow.down.fill"
        }
        else {saveState = "square.and.arrow.down"}
            cell.likeButton.setImage(UIImage(systemName: heartState), for: .normal)
            
        cell.likeCount.text = "\(post.likes)"
        
        cell.shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        cell.shareCount.text = "\(post.shares)"
        
        cell.commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        
        cell.saveButton.setImage(UIImage(systemName: saveState), for: .normal)

        cell.saveLabel.text = "Save"
        cell.delegate = self
        return cell
    }

    func sharePostLink(_ link: String) {
        let items = [link]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        // If using an iPad, configure the popover presentation controller.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view // or button/view that triggered the sharing
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = [] // Adjust if needed
        }
        self.present(activityViewController, animated: true)
    }


    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        generateDummyData()
        super.viewDidLoad()
        homeTableView.dataSource = self
    }
    
    @IBAction func segmentUpdated(_ sender: UISegmentedControl) {
        selectedPosts = []
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nowPlayingSegue" {
                if let destinationVC = segue.destination as? NowPlayingViewController,
                   let cell = sender as? HomePostTableViewCell,
                   let uuid = cell.uuid{
                    print("UUID: \(uuid)")
                    destinationVC.postId = uuid
                }
            }
    }


}
