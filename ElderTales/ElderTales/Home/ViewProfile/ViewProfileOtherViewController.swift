//
//  ViewProfileOtherViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit
import EventKit

class ViewProfileOtherViewController: UIViewController, UITableViewDataSource, HomePostTableViewCellDelegate, LiveOtherViewCellDelegate {
    func didTapProfilePhoto(for cell: LiveOtherTableViewCell) {
    }
    
    func didTapDeleteLiveButton(for cell: LiveOtherTableViewCell) {
        let alert = UIAlertController(title: "Delete Live", message: "Are you sure you want to delete this live session?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            dataController.deleteLive(liveId: cell.uuid)
            // Optionally, update UI or pop viewController if needed
            if(self?.segmentedControl.selectedSegmentIndex == 1){
                self?.viewOtherProfileTableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }

    
    
    func didTapAddEventButton(for cell: LiveOtherTableViewCell) {
        guard let live = dataController.fetchLive(liveId: cell.uuid) else {
            return
        }
        
        requestAccessToCalendar { [weak self] granted in
            guard granted, let strongSelf = self else {
                print("Access to calendar denied.")
                return
            }
            cell.addEventButton.setTitle("Event Added", for: .normal)
            cell.addEventButton.backgroundColor = .clear
            strongSelf.addEventToCalendar(live: live)
        }
    }
    let eventStore = EKEventStore()

    func addEventToCalendar(live: Live) {
        let event = EKEvent(eventStore: eventStore)
        event.title = live.title
        event.startDate = live.beginsOn
        event.endDate = live.beginsOn.addingTimeInterval(2 * 60 * 60) // Assume 2 hours duration
        event.calendar = eventStore.defaultCalendarForNewEvents
        if let user = dataController.fetchUser(userId: live.postedBy){
            event.notes = "Live event hosted by \(user.name)"
        }
        
        
        // Add an alarm to the event to remind the user
        let alarm = EKAlarm(relativeOffset: -1800)  // 1 hour before the event
        event.addAlarm(alarm)

        do {
            try eventStore.save(event, span: .thisEvent)
            showAlertWith(title: "Success", message: "Event added to calendar successfully, with a reminder set for 1 hour before the event.")
        } catch let error as NSError {
            showAlertWith(title: "Error", message: "Failed to save event: \(error.localizedDescription)")
        }
    }
    func requestAccessToCalendar(completion: @escaping (Bool) -> Void) {
        eventStore.requestWriteOnlyAccessToEvents { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting event access: \(error)")
                }
                completion(granted)
            }
        }
    }
    
    func showAlertWith(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true, completion: nil)
        }
    }

    func didTapJoinLiveOtherButton(for cell: LiveOtherTableViewCell) {
        if let liveOngoingMyViewController = storyboard?.instantiateViewController(withIdentifier: "liveOngoingOtherViewController") as? MyLiveOngoingViewController {
            liveOngoingMyViewController.liveId = cell.uuid
            self.navigationController?.pushViewController(liveOngoingMyViewController, animated: true)
        }
        
    }
    
    func didTapJoinLiveMyButton(for cell: LiveOtherTableViewCell) {
        
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
        var identifier = live.isOngoing ? "liveOtherLiveCell" : "liveOtherCell"
        
            identifier = live.isOngoing ? "liveOtherLiveCell" : "liveOtherCell"

        let cell = viewOtherProfileTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! LiveOtherTableViewCell

        // Format and set the date of the live event
        cell.dateOfLive.text = formatDate(live.beginsOn)
        cell.timeOfLive.text = formatTime(live.beginsOn)

         // Assuming you have a default or placeholder image
        cell.storyTitle.text = live.title
        cell.thumbnailUIImage.image = UIImage(named: "otherPhoto") // Placeholder or default image
        
        if let user = dataController.fetchUser(userId: live.postedBy){
            print("\(user.image)")
            cell.username.text = user.name
            cell.profilePhotoUIImage.image = dataController.fetchImage(imagePath: user.image) ?? UIImage(systemName: "person.circle.fill")
        }
        cell.uuid = live.id
        cell.delegate = self
        
        return cell
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM" // e.g., 2 March
        return dateFormatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // e.g., 6:00 PM
        return timeFormatter.string(from: date)
    }

    
    func configurePostCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
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
        
        updateFollowButton(for: user, followButton: self.followButton)
        
        let nib = UINib(nibName: "postCell", bundle: nil)
        viewOtherProfileTableView.register(nib, forCellReuseIdentifier: "postCell")
        registerCellsToTable()
        self.navigationItem.title = user.name
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func updateFollowButton(for user: User, followButton: UIButton) {
        // Check if the current user is already following this user by user ID
        if let currentUser = DataController.shared.currentUser,
           currentUser.following.contains(user.id) {
            // User is currently followed, configure button to show "Unfollow"
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Unfollow", for: .normal)
            followButton.backgroundColor = .clear
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.blue.cgColor
            followButton.setTitleColor(.blue, for: .normal)
        } else {
            // User is not followed, configure button to show "Follow"
            followButton.layer.cornerRadius = 17
            followButton.setTitle("Follow", for: .normal)
            followButton.backgroundColor = .blue
            followButton.layer.borderWidth = 0
            followButton.setTitleColor(.white, for: .normal)
        }
    }

    
    func registerCellsToTable(){
        let cells = ["liveOtherCell", "liveMyLiveCell", "liveMyCell","liveOtherLiveCell", "postCell"]
        for nibName in cells{
            let nib = UINib(nibName: nibName, bundle: nil)
            viewOtherProfileTableView.register(nib, forCellReuseIdentifier: nibName)
        }
    }
    
    func loadData(){
        self.user = dataController.fetchUser(userId: userId)
        selectedPosts = dataController.fetchPosts(postedBy: userId)
        selectedLives = dataController.fetchLives(postedBy: userId)
    }
    
    func setupData(){
        profileImage.image = dataController.fetchImage(imagePath: user?.image)
        userNameLabel.text = user?.name
        descriptionText.text = user?.description
    }
    
    
    @IBAction func didTapFollow(_ sender: UIButton) {
        guard let user = user else { return }

        if let currentUser = DataController.shared.currentUser {
            let isFollowing = currentUser.following.contains(user.id)

            if isFollowing {
                // Unfollow the user
                DataController.shared.toggleFollowUser(userId: user.id)
                followButton.layer.cornerRadius = 17
                followButton.setTitle("Follow", for: .normal)
                followButton.backgroundColor = .blue
                followButton.setTitleColor(.white, for: .normal)
                followButton.layer.borderWidth = 0
            } else {
                // Follow the user
                DataController.shared.toggleFollowUser(userId: user.id)
                followButton.layer.cornerRadius = 17
                followButton.setTitle("Unfollow", for: .normal)
                followButton.backgroundColor = .clear
                followButton.setTitleColor(.blue, for: .normal)
                followButton.layer.borderWidth = 1
                followButton.layer.borderColor = UIColor.blue.cgColor
            }
        }
    }
    
    @IBAction func didTapShareProfile(_ sender: Any) {
        guard let userId = self.user?.id else {
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


    
    @IBAction func segmenteChanged(_ sender: UISegmentedControl) {
        viewOtherProfileTableView.reloadData()
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
