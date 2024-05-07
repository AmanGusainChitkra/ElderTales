//
//  LiveOngoingViewController.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit

class LiveOngoingViewController: UIViewController, UITableViewDataSource {
    
    var comments:[Comment] = []
    var live: Live?
    var liveId: String = ""

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        live = lives.first(where: {$0.id == liveId})
        
        commentTableView.dataSource = self
        startCommentSimulation()
        // Do any additional setup after loading the view.
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


}
