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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        loadPost()
        if let postTitle = post?.title {
            titleLabel.text = postTitle
        }
        player?.play()
        setupPlaybackControls()
        updatePlayPauseButtonForPlayingState()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        commentsTableView.isHidden = false
        print("TableView Frame: \(commentsTableView.frame)")
        print("TableView Visibility: \(commentsTableView.isHidden)")
        print("TableView Alpha: \(commentsTableView.alpha)")
    }
    

    
    private func setupVideoPlayer() {
        guard let url = Bundle.main.url(forResource: "videoSong", withExtension: "mp4") else {
            print("Video file not found.")
            return
        }
        
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = videoPlayView.bounds
        playerLayer.videoGravity = .resizeAspect
        videoPlayView.layer.addSublayer(playerLayer)
        // Don't automatically play the video
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
        // Assume 'posts' is accessible within the scope
        self.post = posts.first(where: { $0.id == postId })
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
