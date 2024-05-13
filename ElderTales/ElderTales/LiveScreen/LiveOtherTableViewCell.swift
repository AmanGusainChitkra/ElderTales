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
    
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var joinLiveButton: UIButton!
    
    var uuid:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePhotoUIImage.layer.cornerRadius = profilePhotoUIImage.frame.width/2
        setupProfilePhotoGesture()
    }

    private func setupProfilePhotoGesture() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
            profilePhotoUIImage.isUserInteractionEnabled = true
            profilePhotoUIImage.addGestureRecognizer(tapGestureRecognizer)
//        usernameLabel.addGestureRecognizer(tapGestureRecognizer)
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        super.setSelected(false, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func tappedAddEvent(_ sender: Any) {
        delegate?.didTapAddEventButton(for: self)
    }
    
    @IBAction func tappedJoinLiveOther(_ sender: Any) {
        delegate?.didTapJoinLiveOtherButton(for: self)
    }
    
    @IBAction func tappedJoinMyLive(_ sender: Any) {
        delegate?.didTapJoinLiveMyButton(for: self)
    }
    
    @IBAction func didTapDeleteLive(_ sender: Any) {
        self.delegate?.didTapDeleteLiveButton(for: self)
    }
    
    @objc private func profilePhotoTapped() {
        // Call delegate or handle navigation to profile page
        delegate?.didTapProfilePhoto(for: self)
    }
    
    weak var delegate: LiveOtherViewCellDelegate?

}


protocol LiveOtherViewCellDelegate: AnyObject {
    
    func didTapAddEventButton(for cell: LiveOtherTableViewCell)
    
    func didTapJoinLiveOtherButton(for cell: LiveOtherTableViewCell)
    
    func didTapJoinLiveMyButton(for cell: LiveOtherTableViewCell)
    
    func didTapDeleteLiveButton(for cell: LiveOtherTableViewCell)
    
    func didTapProfilePhoto(for cell: LiveOtherTableViewCell)
}
