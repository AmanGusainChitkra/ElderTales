//
//  CommentTableViewCell.swift
//  ElderTales
//
//  Created by student on 05/05/24.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var playCommentButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var replyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImage.layer.cornerRadius = userProfileImage.layer.frame.width/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
