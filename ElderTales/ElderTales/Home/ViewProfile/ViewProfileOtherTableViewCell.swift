//
//  ViewProfileOtherTableViewCell.swift
//  ElderTales
//
//  Created by student on 07/05/24.
//

import UIKit

class ViewProfileOtherTableViewCell: UITableViewCell {

    
    var uuid: String?
    //post details
    @IBOutlet weak var profilePhotoUIImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var thumbnailUIImage: UIImageView!

    
    @IBOutlet weak var upcomming: UILabel!
    @IBOutlet weak var intrested: UILabel!
    @IBOutlet weak var dateOfLive: UILabel!
    @IBOutlet weak var timeOfLive: UILabel!
    @IBOutlet weak var addEventButton: UIButton!

    @IBOutlet weak var joinLiveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePhotoUIImage.layer.cornerRadius = profilePhotoUIImage.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    weak var delegate: ViewProfileOtherTableViewCellDelegate?
    
}

protocol ViewProfileOtherTableViewCellDelegate: AnyObject {
}
