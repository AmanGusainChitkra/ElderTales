//
//  LiveOtherTableViewCell.swift
//  ElderTales
//
//  Created by student on 25/04/24.
//

import UIKit

class LiveOtherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profilePhotoUIImage: UIImageView!
    
    @IBOutlet weak var storyTitle: UILabel!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var upcomming: UILabel!
    
    @IBOutlet weak var intrested: UILabel!
    
    @IBOutlet weak var dateOfLive: UILabel!
    
    @IBOutlet weak var timeOfLive: UILabel!

    @IBOutlet weak var thumbnailUIImage: UIImageView!
    
    
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
    }

}
