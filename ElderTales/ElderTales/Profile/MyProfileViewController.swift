//
//  MyProfileViewController.swift
//  ElderTales
//
//  Created by student on 29/04/24.
//

import UIKit

class MyProfileViewController:  UIViewController, UITableViewDataSource, MyProfileTableViewCellDelegate {
    
    var selectedPosts: [Post] {
        get {
            // Determine which posts to return based on the segmented control's selection.
            switch segmentedControl.selectedSegmentIndex {
            case 0: // My Posts
                return posts.filter { $0.postedBy.id == currentUser?.id }
            case 1: // Saved Posts
                return currentUser?.savedPosts ?? []
            default:
                return []
            }
        }
        set {
            // Reload the table view whenever the selection changes.
            profileTableView.reloadData()
        }
    }
    
    func didTapListenButton(for cell: MyProfileTableViewCell) {
    }
    
    func didTapSaveButton(for cell: MyProfileTableViewCell) {
    }
    
    func didTapLikeButton(for cell: MyProfileTableViewCell) {
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

    
    func didTapShareButton(for cell: MyProfileTableViewCell) {
        print("hello")
    }
    
    func didTapCommentButton(for cell: MyProfileTableViewCell) {
        print("hello")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postMyProfile", for: indexPath) as! MyProfileTableViewCell

        let post = selectedPosts[indexPath.row]
        cell.uuid = post.id
        
        cell.profilePhotoUIImage.image = UIImage(named: "youngster")
        cell.usernameLabel.text = post.postedBy.name
        cell.storyTitleLabel.text = post.title
        cell.thumbnailUIImage.image = UIImage(named: "youngster")
        
        // Set the interaction buttons and counts
        var heartState = ""
        if(currentUser!.likedPosts.contains(where: { $0.id == post.id})){
            heartState = "heart.fill"
        }
        else {heartState = "heart"}
            cell.likeButton.setImage(UIImage(systemName: heartState), for: .normal)
            
        cell.likeCount.text = "\(post.likes)"
        
        cell.shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        cell.shareCount.text = "\(post.shares)"
        
        cell.commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        
        cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)

        cell.saveLabel.text = "Save"
        cell.delegate = self
        return cell
    }

    

    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
//        generateDummyData()
        super.viewDidLoad()
        selectedPosts = []
        profileTableView.dataSource = self
        profileImage.layer.cornerRadius = 94/2
        profileImage.layer.borderWidth = 2
    }
    
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "YourSegueIdentifier" { // Replace with your actual segue identifier
//            if let destinationVC = segue.destination as? NowPlayingViewController,
//               let selectedIndexPath = tableView.indexPathForSelectedRow {
//                let selectedPostId = posts[selectedIndexPath.row].id
//                destinationVC.postId = selectedPostId // Assuming your AVPlayerViewController has a postId property
//            }
//        }
//    }


}
