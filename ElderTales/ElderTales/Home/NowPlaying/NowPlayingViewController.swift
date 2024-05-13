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
        let comment = post!.comments[indexPath.row]
        cell.userProfileImage.image = comment.postedBy.image
        cell.usernameLabel.text = comment.postedBy.name
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
    
    private func setupVideoPlayer() {
        // Create a variable for the URL to be used with AVPlayer
        var videoURL: URL?
        guard let post = self.post else {return}
        
        // Check if there's a link in the post and it points to a valid file
        if FileManager.default.fileExists(atPath: post.link) {
            videoURL = URL(string: post.link)
        } else {
            // Fallback to the default video included in the app bundle
            videoURL = Bundle.main.url(forResource: "videoSong", withExtension: "mp4")
        }
        
        // Make sure there's a URL to play, otherwise log an error
        guard let validVideoURL = videoURL else {
            print("No valid video file found.")
            return
        }
        
        // Initialize the player with the chosen video URL
        player = AVPlayer(url: validVideoURL)
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
        guard let currentPost = posts.first(where: { $0.id == postId }),
              let currentUser = currentUser else {
            print("Post or current user not found")
            return
        }
        
        self.post = currentPost
        // Update basic UI elements
        postedByImage.image = currentPost.postedBy.image ?? UIImage(systemName: "person.circle.fill")
        postedByImage.layer.cornerRadius = postedByImage.frame.width/2
        postedByName.text = currentPost.postedBy.name
        likeCountLabel.text = "\(currentPost.likes)"
        shareCountLabel.text = "\(currentPost.shares)"
        commentCountLabel.text = "\(currentPost.comments.count)"
        
        // Update save status
        let isSaved = currentUser.savedPosts.contains(where: { $0.id == currentPost.id })
        saveTextLabel.text = isSaved ? "Saved" : "Save"
        saveButton.setImage(UIImage(systemName: isSaved ? "square.and.arrow.down.fill" : "square.and.arrow.down"), for: .normal)
        
        // Update like status
        let isLiked = currentUser.likedPosts.contains(where: { $0.id == currentPost.id })
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

        if let savedIndex = currentUser?.savedPosts.firstIndex(where: {$0.id == post?.id}) {
            // Post is already saved, so unsave it
            currentUser?.savedPosts.remove(at: savedIndex)
            saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal) // Icon for unsaved
            saveTextLabel.text = "Save" // Text for unsaved state
        } else {
            // Post is not saved, so save it
            currentUser?.savedPosts.append(post!)
            saveButton.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal) // Icon for saved
            saveTextLabel.text = "Saved" // Text for saved state
        }
    }
    
    @IBAction func didTapLikeButton() {
        if let postIndex = posts.firstIndex(where: { $0.id == postId }) {
                let isCurrentlyLiked = likeButton.currentImage == UIImage(systemName: "heart.fill")
                // Toggle the like state based on the current image
                posts[postIndex].likePost(liked: !isCurrentlyLiked)
                currentUser?.likePost(post: posts[postIndex], liked: !isCurrentlyLiked)
                
                // Update the button's image and like count display
                let newImageName = isCurrentlyLiked ? "heart" : "heart.fill"
              likeButton.setImage(UIImage(systemName: newImageName), for: .normal)
               likeCountLabel.text = "\(posts[postIndex].likes)"
                
            } else {
                print("Post with UUID: \(postId) not found.")
            }
        }
    
    func didTapProfilePhoto() {
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "viewProfileController") as? ViewProfileOtherViewController,
           let uuid = post?.id{
            let postedBy = posts.first(where: {$0.id == uuid})?.postedBy
            destinationVC.userId = postedBy?.id ?? ""
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

        // Step 3: Create a new Comment
        let newComment = Comment(postedBy: currentUser!, postedOn: Date(), body: commentText, isQuestion: false) // Adjust `isQuestion` as needed

        // Step 4: Find the current post and add the comment to it
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].comments.append(newComment)
        }
        post?.comments.append(newComment)

        // Step 5: Reload the comment table
        commentsTableView.reloadData()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
}
