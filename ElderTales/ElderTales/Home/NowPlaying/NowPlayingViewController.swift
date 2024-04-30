//
//  NowPlayingViewController.swift
//  ElderTales
//
//  Created by student on 29/04/24.
//

import UIKit
import AVFoundation
import AVKit

class NowPlayingViewController: UIViewController {
    var player: AVPlayer?
    var isPlaying = false
    var postId: String = ""
    var post: Post? {
        didSet {
            setupVideoPlayer()
        }
    }
    
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        loadPost()
        addTimeObserver()
        togglePlayPause()
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
    
    
}
//
//class NowPlayingViewController: UIViewController {
//    var postId: String = ""
//    var post: Post? {
//        didSet {
//            setupVideoPlayer()
//        }
//    }
//    private func setupVideoPlayer() {
//            guard let url = Bundle.main.url(forResource: "videoSong", withExtension: "mp4") else {
//                print("Video file not found.")
//                return
//            }
//
//            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = videoPlayView.bounds
//            playerLayer.videoGravity = .resizeAspect  // Adjust depending on how you want the video to fit
//
//            videoPlayView.layer.addSublayer(playerLayer)
//            player.play()
//        }
//        
//    @IBOutlet weak var videoPlayView: UIView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadPost()
//    }
//
//    private func loadPost() {
//        // Assume 'posts' is accessible within the scope
//        self.post = posts.first(where: { $0.id == postId })
//    }
//}
