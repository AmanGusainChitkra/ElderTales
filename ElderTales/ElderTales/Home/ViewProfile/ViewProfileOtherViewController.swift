//
//  ViewProfileOtherViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit

class ViewProfileOtherViewController: UIViewController, UITableViewDataSource, ViewProfileOtherTableViewCellDelegate {
    func didTapListenButton(for cell: ViewProfileOtherTableViewCell) {
        
    }
    
    func didTapSaveButton(for cell: ViewProfileOtherTableViewCell) {
        
    }
    
    func didTapLikeButton(for cell: ViewProfileOtherTableViewCell) {
        
    }
    
    func didTapShareButton(for cell: ViewProfileOtherTableViewCell) {
        
    }
    
    func didTapCommentButton(for cell: ViewProfileOtherTableViewCell) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "postMyProfile", for: indexPath) as! ViewProfileOtherTableViewCell
        let post = selectedPosts[indexPath.row]

        // Configure the cell for a post
        cell.uuid = post.id
        cell.profilePhotoUIImage.image = post.postedBy.image ?? UIImage(named: "defaultProfilePhoto")
        cell.usernameLabel.text = post.postedBy.name
        cell.storyTitleLabel.text = post.title
        cell.thumbnailUIImage.image = UIImage(named: "defaultThumbnail")
        
        let currentUserLikes = currentUser?.likedPosts.contains(where:{$0.id == post.id})
        let currentUserSaved = currentUser?.savedPosts.contains(where: {$0.id == post.id})
        // Interaction buttons and counts
        cell.likeButton.setImage(UIImage(systemName: currentUserLikes! ? "heart.fill" : "heart"), for: .normal)
        cell.saveButton.setImage(UIImage(systemName: currentUserSaved! ? "square.and.arrow.down.fill" : "square.and.arrow.down"), for: .normal)
        
        cell.shareButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        
        cell.likeCount.text = "\(post.likes)"
        cell.shareCount.text = "\(post.shares)"
        cell.commentButton.setImage(UIImage(systemName: "message"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        cell.saveLabel.text = "Save"
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
