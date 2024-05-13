//
//  HomeViewController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, HomePostTableViewCellDelegate, CategoriesViewControllerDelegate {
    
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var forYouSegmentedControl: UISegmentedControl!
    @IBOutlet weak var clearFilterButton: UIButton!
    @IBOutlet weak var storiesLabel: UILabel!
    var audioVideoSelect:Int = 0 // 0 - All, 1 - Audio, 2 - Video
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "postCell", bundle: nil)
            homeTableView.register(nib, forCellReuseIdentifier: "postCell")
        clearFilterButton.isHidden = true
        homeTableView.dataSource = self
        homeTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeTableView.reloadData()
    }
    
    @IBAction func didTapClearFilters(_ sender: Any) {
        self.selectedCategory = nil
        self.selectedPosts = []
        self.storiesLabel.text = "All Stories"
        self.clearFilterButton.isHidden = true
    }
    
    
    @IBAction func segmentUpdated(_ sender: UISegmentedControl) {
        selectedPosts = []
    }
    
    @IBAction func didTapFilterButton(_ sender: UIButton) {
        if let modalViewController = storyboard?.instantiateViewController(withIdentifier: "selectCategoriesNavigation") as? UINavigationController {
                // Set modal presentation style if necessary
                modalViewController.modalPresentationStyle = .formSheet
                if let categoriesViewController = modalViewController.viewControllers.first as? CategoriesViewController {
                        categoriesViewController.delegate = self
                    }
                present(modalViewController, animated: true, completion: nil)
            }
    }
    
    var selectedCategory: Category?
    var selectedPosts: [Post] {
        get {
            // Filter posts based on whether they are from followed users or all users
            let other_posts = dataController.fetchAllPosts()
            let basePosts: [Post] = {
                switch forYouSegmentedControl.selectedSegmentIndex {
                case 0:  // "For You" - Posts from followed users
                    return other_posts.filter { post in
                        dataController.currentUser!.following.contains { followedUserId in
                            followedUserId == post.postedBy
                        }
                    }
                case 1:
                    return other_posts
                default:
                    return []
                }
            }()

            // Filter the above results based on whether they have video or not
            let mediaFilteredPosts: [Post] = {
                switch audioVideoSelect {
                case 0:
                    return basePosts
                case 1:
                    return basePosts.filter { $0.hasVideo == true }
                case 2:
                    return basePosts.filter { $0.hasVideo == false }
                default:
                    return []
                }
            }()

            // Further filter by the selected category, if any
            if let selectedCategory = selectedCategory {
                return mediaFilteredPosts.filter { post in
                    post.suitableCategories.contains(selectedCategory.title)
                }
            } else {
                return mediaFilteredPosts
            }
        }
        set {
            homeTableView.reloadData()
        }
    }

    
    func didTapProfilePhoto(for cell: HomePostTableViewCell) {
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "viewProfileController") as? ViewProfileOtherViewController,
           let uuid = cell.uuid,
           let post = dataController.fetchPost(postId: uuid){
            destinationVC.userId = post.postedBy
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    func categoryViewController(_ controller: CategoriesViewController, didSelectCategory category: Category) {
        self.clearFilterButton.isHidden = false
        self.storiesLabel.text = "\"\(category.title)\" stories"
        self.selectedCategory = category
        self.selectedPosts = []
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? HomePostTableViewCell
            cell?.delegate?.didTapListenButton(for: cell!)
    }
  
    
    func didTapListenButton(for cell: HomePostTableViewCell) {
        if let nowPlayingVC = storyboard?.instantiateViewController(withIdentifier: "nowPlayingViewController") as? NowPlayingViewController {
            if let uuid = cell.uuid {
                nowPlayingVC.postId = uuid
//                nowPlayingVC.post = fetchPost(with: uuid)
                navigationController?.pushViewController(nowPlayingVC, animated: true)
            }
        }
    }
    
    func didTapSaveButton(for cell: HomePostTableViewCell) {
        guard let post = dataController.fetchPost(postId: cell.uuid!) else { return }

        // Toggle save status in the data model
        dataController.toggleSavePost(postId: post.id)

        // Update the UI based on the new state
        let isNowSaved = dataController.currentUser?.savedPosts.contains(post.id) ?? false
        
        cell.saveButton.setImage(UIImage(systemName: isNowSaved ? "square.and.arrow.down.fill" : "square.and.arrow.down"), for: .normal)
        cell.saveLabel.text = isNowSaved ? "Saved" : "Save"
    }

    
    func didTapFollowButton(for cell: HomePostTableViewCell) {
        guard let postId = cell.uuid,
              let post = DataController.shared.fetchPost(postId: postId) else {
            print("Post not found.")
            return
        }

        // Toggle follow status in the data model
        DataController.shared.toggleFollowUser(userId: post.postedBy)

        // Update the UI based on the new state
        let isFollowing = DataController.shared.currentUser?.following.contains(post.postedBy) ?? false
        configureFollowButton(cell.followButton, isFollowing: isFollowing)
    }

    func configureFollowButton(_ button: UIButton, isFollowing: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = isFollowing ? "Unfollow" : "Follow"
        config.baseBackgroundColor = isFollowing ? .clear : .tertiarySystemFill
        config.baseForegroundColor = isFollowing ? .white : .link

        let font = UIFont(name: "Helvetica Neue", size: 11.0) ?? UIFont.systemFont(ofSize: 11)
        let attributes = AttributeContainer([
            .font: UIFont(descriptor: font.fontDescriptor, size: 11),
            .foregroundColor: UIColor.accent
        ])
        config.attributedTitle = AttributedString(config.title ?? "None", attributes: attributes)
        
        button.configuration = config
    }

    
    func didTapLikeButton(for cell: HomePostTableViewCell) {
        guard let post = dataController.fetchPost(postId: cell.uuid!) else { return }

        // Toggle like status in the data model
        DataController.shared.toggleLikePost(postId: post.id)

        // Update the UI based on the new state
        let isNowLiked = dataController.currentUser?.likedPosts.contains(post.id) ?? false
        cell.likeButton.setImage(UIImage(systemName: isNowLiked ? "heart.fill" : "heart"), for: .normal)

        // Update like count display
        if let updatedPostIndex = dataController.posts.firstIndex(where: { $0.id == post.id }) {
            let updatedLikeCount = dataController.posts[updatedPostIndex].likes
            cell.likeCount.text = "\(updatedLikeCount)"
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomePostTableViewCell

        let post = selectedPosts[indexPath.row]
        cell.uuid = post.id
        let isSaved = dataController.currentUser?.savedPosts.contains(post.id) ?? false
        
        if let user = dataController.fetchUser(userId: post.postedBy){
            cell.usernameLabel.text = user.name
            cell.profilePhotoUIImage.image = dataController.fetchImage(imagePath: user.image) ?? UIImage(systemName: "person.circle.fill")
        }
        
        cell.storyTitleLabel.text = post.title
        cell.thumbnailUIImage.image = UIImage(named: "youngster")
        
        // Set the interaction buttons and counts
        var heartState = ""
        if(dataController.currentUser!.likedPosts.contains(post.id)){
            heartState = "heart.fill"
        }
        else {heartState = "heart"}
            cell.likeButton.setImage(UIImage(systemName: heartState), for: .normal)

        
        if(dataController.currentUser?.following.contains(post.postedBy) ?? false){
            cell.followButton.isHidden = true
        } else {
            cell.followButton.isHidden = false
        }
        
        if isSaved {
            cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
            cell.saveLabel.text = "Saved"
        } else {
            cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
            cell.saveLabel.text = "Save"
        }
            
        cell.likeCount.text = "\(post.likes)"
        
        cell.shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        cell.shareCount.text = "\(post.shares)"
        
        cell.commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"

        cell.audioVideoIndicatorImage.image = UIImage(systemName: post.hasVideo ? "video.fill" : "headphones")
        cell.listenButton.titleLabel?.text = post.hasVideo ? "Play" : "Listen"

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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "nowPlayingSegue" {
//                if let destinationVC = segue.destination as? NowPlayingViewController,
//                   let cell = sender as? HomePostTableViewCell,
//                   let uuid = cell.uuid{
//                    print("UUID: \(uuid)")
//                    destinationVC.postId = uuid
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
    


}
