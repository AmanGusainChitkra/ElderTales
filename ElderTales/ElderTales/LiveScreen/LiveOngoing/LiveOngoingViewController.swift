//
//  LiveOngoingViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit
import AVFoundation


class LiveOngoingViewController: UIViewController, UITableViewDataSource {
    
    var comments:[Comment] = []
    var live: Live?
    var liveId: String = ""
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "liveCommentCell", for: indexPath) as! LiveCommentTableViewCell
        
        let comment = comments[indexPath.row]
        
        guard let user = dataController.fetchUser(userId: comment.postedBy) else {return cell}
        
        if let imagePath = user.image{
            cell.profileImage.image = UIImage(contentsOfFile: imagePath) ?? UIImage(named: imagePath)
        } else {
            cell.profileImage.image = UIImage(systemName: "person.circle.fill")
        }
        cell.commentTextView.text = comment.body
        
        return cell
    }
    
    

    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var liveView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        live = dataController.fetchLive(liveId: liveId)
        commentTableView.dataSource = self
        startCommentSimulation()
        configureVideoPlayer()
        self.navigationItem.title = live?.title
        self.navigationItem.largeTitleDisplayMode = .never
    }

    func configureVideoPlayer() {
        guard let filePath = Bundle.main.path(forResource: "videoSong", ofType: "mp4") else {
            print("Video file not found")
            return
        }
        let fileURL = URL(fileURLWithPath: filePath)
        player = AVPlayer(url: fileURL)
        playerLayer = AVPlayerLayer(player: player)
        
        if let playerLayer = playerLayer {
            playerLayer.frame = liveView.bounds
            liveView.layer.addSublayer(playerLayer)
            player?.play()
        }
    }

    func startCommentSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            // Create a new comment
            let newComment = Comment(postedBy: dataController.users[1].id, postedOn: Date(), postId: liveId, body: "New comment coming in!", isQuestion: false)

            DispatchQueue.main.async {
                // Append the new comment to the data source first
                self.comments.append(newComment)
                let indexPath = IndexPath(row: self.comments.count - 1, section: 0)

                // Begin table updates
                self.commentTableView.beginUpdates()
                self.commentTableView.insertRows(at: [indexPath], with: .automatic)
                self.commentTableView.endUpdates()

                // Scroll to the new comment
                self.commentTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = liveView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.play()
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
