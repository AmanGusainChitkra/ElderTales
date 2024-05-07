//
//  LiveOngoingViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit
import AVFoundation

class MyLiveOngoingViewController: UIViewController, UITableViewDataSource {
    
    var comments:[Comment] = []
    var live: Live?
    var liveId: String = ""
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "liveCommentCell", for: indexPath) as! LiveCommentTableViewCell
        
        let comment = comments[indexPath.row]
        cell.profileImage.image = comment.postedBy.image
        cell.userNameLabel.text = comment.postedBy.name
        cell.commentTextView.text = comment.body
        
        return cell
    }
    
    

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var liveView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        live = lives.first(where: {$0.id == liveId})
        commentTableView.dataSource = self
        startCommentSimulation()
        setupVideoCapture()
    }
    
    func setupVideoCapture() {
        // Create a capture session
        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            print("Unable to access front camera")
            return
        }

        // Add input to session
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("Failed to add input to capture session")
            return
        }

        // Setup the preview layer
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = liveView.bounds
        previewLayer.videoGravity = .resizeAspectFill // Adjust as needed
        liveView.layer.addSublayer(previewLayer)

        // Save session and preview layer
        captureSession = session
        videoPreviewLayer = previewLayer

        // Start the session
        session.startRunning()
    }



    func startCommentSimulation() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            // Create a new comment
            let newComment = Comment(postedBy: users[1], postedOn: Date(), body: "New comment coming in!", isQuestion: false)

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
        videoPreviewLayer?.frame = liveView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession?.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }


}
