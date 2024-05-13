//
//  NowPlayingViewController.swift
//  ElderTales
//
//  Created by student on 29/04/24.
//

import UIKit
import AVFoundation
import AVKit

class NowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post!.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "commentTableCell", for: indexPath) as! CommentTableViewCell
        let comment = postComments[indexPath.row]
        if let user = dataController.fetchUser(userId: comment.postedBy){
            cell.userProfileImage.image = dataController.fetchImage(imagePath: user.image) ?? UIImage(systemName: "person.circle.fill")
            cell.usernameLabel.text = user.name
        }
        cell.commentTextView.text = comment.body
        print("cell created")
        return cell
    }
    
    var player: AVPlayer?
    var isPlaying = false
    var postId: String = ""
    var post: Post? {
        didSet {
            setupVideoPlayer()
            commentsTableView.reloadData()
        }
    }
    var postComments:[Comment] = []
    
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var postedByImage: UIImageView!
    @IBOutlet weak var postedByName: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var saveTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        loadPost()
        print("Post loaded")
        player?.play()
        setupPlaybackControls()
        updatePlayPauseButtonForPlayingState()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
    }
    var videoURL:URL?
    
    private func setupVideoPlayer() {
        guard let post = self.post else { return }
        
        print("Attempting to load video from link: \(post.link)")

        // Create a URL from the post link assuming it's a valid file path
        videoURL = URL(fileURLWithPath: post.link)

        // Check if the file exists at the given path
        if FileManager.default.fileExists(atPath: post.link) {
            print("File exists at path: \(post.link)")
        } else {
            print("File does not exist, loading default video")
            // Fallback to the default video included in the app bundle
            guard let fallbackURL = Bundle.main.url(forResource: "videoSong", withExtension: "mp4") else {
                print("Failed to load fallback video.")
                return
            }
            videoURL = fallbackURL
        }
        
        // Initialize the player with the chosen video URL
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoPlayView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoPlayView.layer.addSublayer(playerLayer)
        
        // Set the initial playing state and update the play/pause button accordingly
        isPlaying = false
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }


    
    private func setupPlaybackControls() {
        // Only set up observer and time observer if the player is initialized
        guard player != nil else { return }
        addTimeObserver()
        player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
    }
    
    private func updatePlayPauseButtonForPlayingState() {
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        isPlaying = true
    }
    
    @IBAction func playPauseTapped(_ sender: UIButton) {
        togglePlayPause()
    }
    
    private func togglePlayPause() {
        if isPlaying {
            player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        isPlaying.toggle()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard let duration = player?.currentItem?.duration else {
            print("notfound")
            return }
        let totalSeconds = CMTimeGetSeconds(duration)
        let value = Float64(sender.value) * totalSeconds
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        player?.seek(to: seekTime)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        let expectedHeight: CGFloat = 300  // Adjust based on your UI needs
        commentsTableView.frame = CGRect(x: 0, y: 727, width: view.bounds.width, height: expectedHeight)

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            timeSlider.maximumValue = Float(duration)
        }
    }
    
    private func loadPost() {
        guard let currentPost = dataController.fetchPost(postId: postId) else {return}
        self.post = currentPost
        self.postComments = dataController.fetchCommentsForPost(post: currentPost)
        
                // Update basic UI elements
        guard let user = dataController.fetchUser(userId: currentPost.postedBy) else {return}
        
        postedByImage.image = UIImage(contentsOfFile: user.image ?? "") ?? UIImage(named: user.image ?? "") ?? UIImage(systemName: "person.circle.fill")
        postedByImage.layer.cornerRadius = postedByImage.frame.width/2
        postedByName.text = user.name
        likeCountLabel.text = "\(currentPost.likes)"
        shareCountLabel.text = "\(currentPost.shares)"
        commentCountLabel.text = "\(currentPost.comments.count)"
        
        // Update save status
        let isSaved = dataController.currentUser!.savedPosts.contains(currentPost.id)
        saveTextLabel.text = isSaved ? "Saved" : "Save"
        saveButton.setImage(UIImage(systemName: isSaved ? "square.and.arrow.down.fill" : "square.and.arrow.down"), for: .normal)
        
        // Update like status
        let isLiked = dataController.currentUser!.likedPosts.contains(currentPost.id)
        likeButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        
        setupProfilePhotoGesture()
    }
    
    private func setupProfilePhotoGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
        postedByImage.isUserInteractionEnabled = true
        postedByImage.addGestureRecognizer(tapGestureRecognizer)
//        usernameLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func profilePhotoTapped() {
        // Call delegate or handle navigation to profile page
        self.didTapProfilePhoto()
    }
    
    @IBAction func didTapShareButton() {
        let postLink = "https://eldertales.com/post/\(postId)"
        sharePostLink(postLink)
            
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
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let strongSelf = self, let duration = strongSelf.player?.currentItem?.duration else { return }
            let durationSeconds = CMTimeGetSeconds(duration)
            let seconds = CMTimeGetSeconds(time)
            strongSelf.timeSlider.value = Float(seconds / durationSeconds)
        }
    }
    
    @IBAction func didTapSaveButton() {
        guard let post = self.post else { return }

        // Toggle save status in the data model
        dataController.toggleSavePost(postId: post.id)

        // Update the UI based on the new state
        let isNowSaved = dataController.currentUser?.savedPosts.contains(post.id) ?? false
        
        saveButton.setImage(UIImage(systemName: isNowSaved ? "square.and.arrow.down.fill" : "square.and.arrow.down"), for: .normal)
        saveTextLabel.text = isNowSaved ? "Saved" : "Save"
    }

    @IBAction func didTapLikeButton() {
        guard let post = self.post else { return }

        // Toggle like status in the data model
        DataController.shared.toggleLikePost(postId: post.id)

        // Update the UI based on the new state
        let isNowLiked = dataController.currentUser?.likedPosts.contains(post.id) ?? false
        likeButton.setImage(UIImage(systemName: isNowLiked ? "heart.fill" : "heart"), for: .normal)

        // Update like count display
        if let updatedPostIndex = dataController.posts.firstIndex(where: { $0.id == post.id }) {
            let updatedLikeCount = dataController.posts[updatedPostIndex].likes
            likeCountLabel.text = "\(updatedLikeCount)"
        }
    }

    
    func didTapProfilePhoto() {
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "viewProfileController") as? ViewProfileOtherViewController{
            let postedBy = post!.postedBy
            destinationVC.userId = postedBy
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func didTapSendComment(_ sender: Any) {
        // Step 1: Retrieve text from the UITextField
        guard let commentText = commentTextField.text, !commentText.isEmpty else {
            // Step 2: If comment is nil or empty, show an alert
            showAlert(message: "Please enter a comment before sending.")
            return
        }
        dataController.newComment(post: post!, postedBy: dataController.currentUser!, body: commentText)
        commentsTableView.reloadData()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
}
