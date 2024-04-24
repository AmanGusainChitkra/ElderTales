//
//  HomeViewController.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postHome", for: indexPath) as! HomePostTableViewCell
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let post = posts[indexPath.row]
        
        // Configure the cell with data from the post
        cell.profilePhotoUIImage.image = UIImage(named: "youngster")
        cell.usernameLabel.text = post.postedBy.name
        cell.storyTitleLabel.text = post.title
        cell.thumbnailUIImage.image = UIImage(named: "youngster")
        
        // Set the interaction buttons and counts
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        cell.likeCount.text = "\(post.likes)"
        
        cell.shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        cell.shareCount.text = "\(post.shares)"
        
        cell.commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        cell.commentCount.text = "\(post.comments.count)"
        
        cell.saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)

        cell.saveLabel.text = "Save"
        
        
        return cell
    }

    

    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        generateDummyData()
        super.viewDidLoad()
        homeTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
