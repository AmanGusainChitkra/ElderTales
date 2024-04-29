//
//  HomeViewController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UITableViewDataSource, HomePostTableViewCellDelegate {
    
    var selectedPosts: [Post] = posts
    
    func didTapListenButton(for cell: HomePostTableViewCell) {
        if let uuid = cell.uuid {
                if let post = posts.first(where: { $0.id == uuid }) {
                    print("Playing post with UUID: \(uuid) titled: \(post.title)")

                } else {
                    print("Post with UUID: \(uuid) not found.")
                }
            }
    }
    
    func didTapSaveButton(for cell: HomePostTableViewCell) {
        print("hello")
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
        print("hello")
    }
    
    func didTapCommentButton(for cell: HomePostTableViewCell) {
        print("hello")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postHome", for: indexPath) as! HomePostTableViewCell

        let post = posts[indexPath.row]
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
        
        cell.commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        
        cell.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)

        cell.saveLabel.text = "Save"
        cell.delegate = self
        return cell
    }

    

    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        generateDummyData()
        super.viewDidLoad()
        homeTableView.dataSource = self
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
