//
//  HomePostTableViewCell.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {

    
    //post details
    @IBOutlet weak var profilePhotoUIImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var thumbnailUIImage: UIImageView!
    
    //post interaction buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareCount: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
