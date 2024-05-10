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
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDetails()
        selectedPosts = []
        profileTableView.dataSource = self
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
        profileImage.layer.borderWidth = 1

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true  // Make sure user interaction is enabled
        profileImage.addGestureRecognizer(tapGesture)
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

    
    override func viewDidAppear(_ animated: Bool) {
        self.profileTableView.reloadData()
        setDetails()
    }
    
    func setDetails(){
        var followersCount: Int = 0
        followersCount = users.filter({$0.following.contains(where: {$0.id == currentUser?.id})}).count
        
        profileImage.image = currentUser?.image
        postsCountLabel.text = "\(posts.filter({$0.postedBy.id == currentUser?.id}).count)"
        followersCountLabel.text = "\(followersCount)"
        descriptionLabel.text = currentUser?.description
        usernameLabel.text = currentUser?.name  
        print("details set")
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        selectedPosts = []
    }
    
    @IBAction func didTapEditProfile(_ sender: Any) {
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
        if segue.identifier == "nowPlayingSegue" {
                if let destinationVC = segue.destination as? NowPlayingViewController,
                   let cell = sender as? HomePostTableViewCell,
                   let uuid = cell.uuid{
                    print("UUID: \(uuid)")
                    destinationVC.postId = uuid
                }
            }
        if segue.identifier == "viewProfileSegue"{
            if let destinationVC = segue.destination as? ViewProfileOtherViewController,
               let cell = sender as? HomePostTableViewCell,
               let uuid = cell.uuid{
                let postedBy = posts.first(where: {$0.id == uuid})?.postedBy
                destinationVC.userId = postedBy?.id ?? ""
            }
        }
        if segue.identifier == "editProfileSegue" { // Replace with your actual segue identifier
                if let navigationController = segue.destination as? UINavigationController,
                   let editProfileVC = navigationController.viewControllers.first as? EditProfileViewController {
                    editProfileVC.userId = currentUser?.id ?? ""
                    // Set any other data needed for the EditProfileViewController
                }
            }
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
