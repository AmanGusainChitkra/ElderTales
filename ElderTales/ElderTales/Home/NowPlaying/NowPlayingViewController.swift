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
    var postId: String = ""
    var post: Post? {
        didSet {
            setupVideoPlayer()
        }
    }
    private func setupVideoPlayer() {
            guard let url = Bundle.main.url(forResource: "videoSong", withExtension: "mp4") else {
                print("Video file not found.")
                return
            }

            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = videoPlayView.bounds
            playerLayer.videoGravity = .resizeAspect  // Adjust depending on how you want the video to fit

            videoPlayView.layer.addSublayer(playerLayer)
            player.play()
        }
        
    @IBOutlet weak var videoPlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }

    private func loadPost() {
        // Assume 'posts' is accessible within the scope
        self.post = posts.first(where: { $0.id == postId })
    }
}
/*
class NowPlayingViewController: UIViewController {
    var postId: String = ""
    var post: Post? {
        didSet {
            setupVideoPlayer()
        }
    }
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
    }

    func loadPost() {
        // Simulate loading post data
        self.post = posts.first(where: { $0.id == postId })
    }

    func setupVideoPlayer() {
        guard let urlString = post?.link, let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspectFill // Ensure the video covers the whole area

        view.layer.insertSublayer(playerLayer!, at: 0) // Add player layer at the bottom of all layers
        player?.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds // Ensure the player layer covers the full bounds of the view
    }

    deinit {
        player?.pause()
        player?.removeObserver(self, forKeyPath: "status")
    }
}
 */
//
//
//class NowPlayingViewController: UIViewController {
//    var postId: String = ""
//    var post: Post? = nil
//    var player: AVPlayer?
//    var playerLayer: AVPlayerLayer?
//    
//    override func viewDidLoad() {
//            super.viewDidLoad()
//
//            post = posts.first(where: { $0.id == postId })
//            namePostLabel.text = post?.title
//
//            setupVideoPlayer()
//        }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        playerLayer?.frame = view.bounds
//        view.layer.addSublayer(playerLayer!)
//    }
//
//    
//    func setupVideoPlayer() {
//        guard let post = post, let url = URL(string: post.link) else {
//            print("Invalid URL or post data")
//            return
//        }
//
//        player = AVPlayer(url: url)
//        playerLayer = AVPlayerLayer(player: player)
//        playerLayer?.frame = view.bounds
//        view.layer.addSublayer(playerLayer!)
//
//        player?.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
//        
//    }
//
//    override func observeValue(forKeyPath keyPath: String?,
//                               of object: Any?,
//                               change: [NSKeyValueChangeKey : Any]?,
//                               context: UnsafeMutableRawPointer?) {
//        if keyPath == "status" {
//            switch player?.status {
//            case .readyToPlay:
//                player?.play()
//            case .failed:
//                print("Failed to load video")
//            default:
//                break
//            }
//        }
//    }
//
//    deinit {
//        player?.removeObserver(self, forKeyPath: "status")
//    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "nowPlayingSegue" {
//                if let destinationVC = segue.destination as? NowPlayingViewController,
//                   let cell = sender as? HomePostTableViewCell,
//                   let uuid = cell.uuid{
//                    print("UUID: \(uuid)")
//                    destinationVC.postId = uuid
//                }
//            }
//    }


//}
