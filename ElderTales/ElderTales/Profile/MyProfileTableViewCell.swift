//
//  MyProfileTableViewCell.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit

class MyProfileTableViewCell: UITableViewCell {

    
    var uuid: String?
    //post details
    @IBOutlet weak var profilePhotoUIImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var thumbnailUIImage: UIImageView!
    @IBOutlet weak var listenButton: UIButton!
    
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
        profilePhotoUIImage.layer.cornerRadius = 10
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
    
    @IBAction func tappedLikeButton(_ sender: UIButton) {
        delegate?.didTapLikeButton(for: self)
    }
    
    @IBAction func tappedShareButton(_ sender: UIButton) {
        delegate?.didTapShareButton(for:self)
    }
    
    @IBAction func tappedCommentButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
    }
    
    weak var delegate: MyProfileTableViewCellDelegate?
    
}

protocol MyProfileTableViewCellDelegate: AnyObject {
    
    func didTapListenButton(for cell: MyProfileTableViewCell)
    
    func didTapSaveButton(for cell: MyProfileTableViewCell)
    
    func didTapLikeButton(for cell: MyProfileTableViewCell)
    
    func didTapShareButton(for cell: MyProfileTableViewCell)
    
    func didTapCommentButton(for cell: MyProfileTableViewCell)
    
}
