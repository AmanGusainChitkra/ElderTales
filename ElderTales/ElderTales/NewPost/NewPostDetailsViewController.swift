//
//  NewPostDetailsViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit
import AVFoundation


class NewPostDetailsViewController: UIViewController {
    var postURL:URL? = nil
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
    }
    func setupVideoPlayer() {
        guard let videoURL = postURL else {
            print("Video URL is not set")
            return
        }

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspect // Adjust the video to fit within the bounds
        videoView.layer.addSublayer(playerLayer!)
        player?.play()

        // Ensure the layer aligns with the orientation of the video content
        if let track = AVAsset(url: videoURL).tracks(withMediaType: .video).first {
            let size = track.naturalSize
            let transform = track.preferredTransform
            if (size.width == transform.tx && size.height == transform.ty) {
                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: .pi))
            } else if (transform.tx == 0 && transform.ty == 0) {
                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: 0))
            } else if (transform.tx == 0 && transform.ty == size.width) {
                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: .pi/2))
            } else {
                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2))
            }
        }
    }

    func createAndAddNewPost() {
        let title = titleText.text ??  "NoTitle"
        let coverImage = UIImage(named: "youngster")! // Make sure this exists in your assets
        let videoLink = postURL?.absoluteString ?? ""
        let hasVideo = true

        let newPost = Post(
            postedBy: currentUser!,
            length: 120,
            title: title,
            cover: coverImage,
            link: videoLink,
            hasVideo: hasVideo
        )
        posts.insert(newPost, at: 0)
        print("podt added: \(newPost.title)")
        
    }
    
    @IBAction func postTapped(_ sender: Any) {
        createAndAddNewPost()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
