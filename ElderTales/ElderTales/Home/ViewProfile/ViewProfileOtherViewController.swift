//
//  ViewProfileOtherViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit

class ViewProfileOtherViewController: UIViewController, UITableViewDataSource, HomePostTableViewCellDelegate, ViewProfileOtherTableViewCellDelegate {
    
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
        guard let postIndex = posts.firstIndex(where: {$0.id == cell.uuid}) else { return }
        let post = posts[postIndex]
        
        if let savedIndex = currentUser?.savedPosts.firstIndex(where: {$0.id == post.id}) {
            // Post is already saved, so unsave it
            currentUser?.savedPosts.remove(at: savedIndex)
            cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal) // Icon for unsaved
            cell.saveLabel.text = "Save" // Text for unsaved state
        } else {
            // Post is not saved, so save it
            currentUser?.savedPosts.append(post)
            cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal) // Icon for saved
            cell.saveLabel.text = "Saved" // Text for saved state
        }
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
    
    func didTapProfilePhoto(for cell: HomePostTableViewCell) {
    }
    
    func didTapFollowButton(for cell: HomePostTableViewCell) {
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return selectedPosts.count
        case 1:
            return selectedLives.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return configurePostCell(for: tableView, at: indexPath)
        case 1:
            return configureLiveCell(for: tableView, at: indexPath)
        default:
            fatalError("Unexpected Segment Index")
        }
    }

    func configureLiveCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let live = selectedLives[indexPath.row]
        let identifier = live.isOngoing ? "liveOther" : "liveOtherLive"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ViewProfileOtherTableViewCell

        // Configure the cell for a live session
        cell.profilePhotoUIImage.image = live.postedBy.image
        cell.usernameLabel.text = live.postedBy.name
        cell.storyTitleLabel.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "defaultThumbnail")
        cell.uuid = live.id
        cell.delegate = self

        return cell
    }

    
    func configurePostCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomePostTableViewCell

        let post = selectedPosts[indexPath.row]
        let isSaved = currentUser?.savedPosts.contains(where: {$0.id == post.id}) ?? false

        cell.uuid = post.id
        
        cell.profilePhotoUIImage.image = post.postedBy.image
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
        
//        if(currentUser?.following.contains(where: {$0.id == post.postedBy.id}) ?? false){
//            cell.followButton.isHidden = true
//        } else {
//            cell.followButton.isHidden = false
//        }
        cell.followButton.isHidden = true
        cell.likeCount.text = "\(post.likes)"
        
        cell.shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        cell.shareCount.text = "\(post.shares)"
        
        cell.commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        
        if isSaved {
                cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
                cell.saveLabel.text = "Saved"
            } else {
                cell.saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
                cell.saveLabel.text = "Save"
            }
        
        cell.audioVideoIndicatorImage.image = UIImage(systemName: post.hasVideo ? "video.fill" : "headphones")
        cell.listenButton.titleLabel?.text = post.hasVideo ? "Play" : "Listen"


        cell.delegate = self
        return cell
    }


    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var viewOtherProfileTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var followButton: UIButton!
    
    
    
    
    var userId: String = ""
    var user: User?
    var selectedPosts:[Post] = []
    var selectedLives:[Live] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        setupData()
        viewOtherProfileTableView.dataSource = self
        guard let user = user else { return }

        if let index = currentUser?.following.firstIndex(where: { $0.id == user.id }) {
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Unfollow", for: .normal)
            followButton.tintColor = .clear
            followButton.layer.borderWidth = 1
        } else {
            // Follow the user
            
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Follow", for: .normal)
            followButton.tintColor = .blue
            followButton.layer.borderWidth = 0
            
        }
        let nib = UINib(nibName: "postCell", bundle: nil)
        viewOtherProfileTableView.register(nib, forCellReuseIdentifier: "postCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func loadData(){
        user = users.first(where: {$0.id == userId})
        selectedPosts = posts.filter({$0.postedBy.id == user?.id})
        selectedLives = lives.filter({$0.postedBy.id == user?.id})
    }
    
    func setupData(){
        profileImage.image = user?.image
        userNameLabel.text = user?.name
        descriptionText.text = user?.description
        
    }
    
    
    @IBAction func didTapFollow(_ sender: UIButton) {
        guard let user = user else { return }

        if let index = currentUser?.following.firstIndex(where: { $0.id == user.id }) {
            // User is already followed, unfollow them
            currentUser?.following.remove(at: index)
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Follow", for: .normal)
            followButton.tintColor = .blue
            followButton.layer.borderWidth = 0
        } else {
            // Follow the user
            currentUser?.following.append(user)
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Unfollow", for: .normal)
            followButton.tintColor = .clear
            followButton.layer.borderWidth = 1
            
        }
    }

    
    @IBAction func segmenteChanged(_ sender: UISegmentedControl) {
        viewOtherProfileTableView.reloadData()
    }
    

}
