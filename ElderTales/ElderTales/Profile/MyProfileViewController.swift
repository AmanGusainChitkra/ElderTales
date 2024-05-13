//
//  MyProfileViewController.swift
//  ElderTales
//
//  Created by student on 29/04/24.
//

import UIKit

class MyProfileViewController:  UIViewController, UITableViewDataSource, HomePostTableViewCellDelegate, UITableViewDelegate {
    
    var currentUser:User?
    
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
    
    func didTapProfilePhoto(for cell: HomePostTableViewCell) {
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
    
    var selectedPosts: [Post] {
        get {
            let allPosts = dataController.fetchAllPosts()
            switch segmentedControl.selectedSegmentIndex {
            case 0: // My Posts
                // Return posts where the current user is the author
                return allPosts.filter { $0.postedBy == dataController.currentUser?.id }
            case 1: // Saved Posts
                // Return posts that the current user has saved
                if let savedPostIds = dataController.currentUser?.savedPosts {
                    return allPosts.filter { savedPostIds.contains($0.id) }
                }
                return []
            default:
                return []
            }
        }
        set {
            // Assuming there is a UITableView named `profileTableView` that needs to be reloaded
            // whenever the selectedPosts are set.
            profileTableView.reloadData()
        }
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
        
        cell.followButton.isHidden = true

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

    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var postCountStack: UIStackView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        selectedPosts = []
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true  // Make sure user interaction is enabled
        profileImage.addGestureRecognizer(tapGesture)
        
        let tapPostCountGesture = UITapGestureRecognizer(target:self,action: #selector(postCountStackTapped))
        postCountStack.isUserInteractionEnabled = true
        postCountStack.addGestureRecognizer(tapPostCountGesture)
        
        let nib = UINib(nibName: "postCell", bundle: nil)
        profileTableView.register(nib, forCellReuseIdentifier: "postCell")
    }
    
    @objc func postCountStackTapped() {
        // Calculate the new y-offset
        let newYOffset = self.contentScrollView.contentOffset.y + 400
        
        let maxOffsetY = self.contentScrollView.contentSize.height - self.contentScrollView.bounds.height
        
        if newYOffset > maxOffsetY {
            self.contentScrollView.setContentOffset(CGPoint(x: 0, y: maxOffsetY), animated: true)
        } else {
            self.contentScrollView.setContentOffset(CGPoint(x: 0, y: newYOffset), animated: true)
        }
    }

    
    @objc func profileImageTapped() {
        let imageView = UIImageView(image: profileImage.image)
        imageView.frame = UIScreen.main.bounds
        imageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)

        let viewController = UIViewController()
        viewController.view = imageView
        viewController.modalPresentationStyle = .overFullScreen  // Optional: Use .fullScreen for iOS versions below 13
        viewController.modalTransitionStyle = .crossDissolve  // Optional: Adds a fade-in, fade-out effect

        present(viewController, animated: true, completion: nil)
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? HomePostTableViewCell
            cell?.delegate?.didTapListenButton(for: cell!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.profileTableView.reloadData()
        setDetails()
    }
    
    func setDetails(){
        currentUser = dataController.currentUser
        print("Refresehd")
        var followersCount: Int = 0
        followersCount = dataController.getFollowersCount(userId: currentUser!.id)
        
        profileImage.image = dataController.fetchImage(imagePath: currentUser?.image) ?? UIImage(systemName: "person.circle.fill")
        postsCountLabel.text = "\(dataController.getPostsCount(userId: currentUser!.id))"
        followersCountLabel.text = "\(followersCount)"
        descriptionLabel.text = currentUser?.description
        usernameLabel.text = currentUser?.name  
        print("details set")
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        selectedPosts = []
    }
    
    @IBAction func didTapEditProfile(_ sender: Any) {
        if let editProfileNavigation = storyboard?.instantiateViewController(withIdentifier: "editProfileNavigation") as? UINavigationController{
            editProfileNavigation.modalPresentationStyle = .formSheet
            if let editProfileVC = editProfileNavigation.viewControllers.first as? EditProfileViewController {
             editProfileVC.userId = currentUser?.id ?? ""
                editProfileVC.onDismiss = {[weak self] in self?.setDetails()}
            present(editProfileNavigation, animated: true, completion: nil)
         }
        }
    }
    
    
    @IBAction func didTapShareProfile(_ sender: Any) {
        guard let userId = currentUser?.id else {
               print("User ID is unavailable")
               return
           }
           
           let urlString = "https://eldertales.com/userId=\(userId)"
           guard let url = URL(string: urlString) else {
               print("Failed to create URL")
               return
           }
           
           // Proceed to share the URL
           shareUserProfile(url: url)
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
//        if segue.identifier == "editProfileSegue" { // Replace with your actual segue identifier
//                if let navigationController = segue.destination as? UINavigationController,
//                   let editProfileVC = navigationController.viewControllers.first as? EditProfileViewController {
//                    editProfileVC.userId = currentUser?.id ?? ""
//                }
//            }
    }
    
    func shareUserProfile(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        // For iPad, you must present the activity view controller in a popover.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view  // Configure the view from which the popover arises
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []  // No arrow directions
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    


}
