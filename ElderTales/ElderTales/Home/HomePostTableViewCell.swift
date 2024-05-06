//
//  HomePostTableViewCell.swift
//  ElderTales
//
//  Created by student on 24/04/24.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {

    
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
    
    @IBAction func tappedLikeButton(_ sender: UIButton) {
        delegate?.didTapLikeButton(for: self)
    }
    
    @IBAction func tappedShareButton(_ sender: UIButton) {
        delegate?.didTapShareButton(for:self)
    }
    
    @IBAction func tappedCommentButton(_ sender: UIButton) {
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        delegate?.didTapSaveButton(for: self)
    }
    
    @IBAction func tappedListenButton(_ sender: UIButton) {
        delegate?.didTapListenButton(for: self)
    }
    
    
    weak var delegate: HomePostTableViewCellDelegate?
    
}

protocol HomePostTableViewCellDelegate: AnyObject {
    
    func didTapListenButton(for cell: HomePostTableViewCell)
    
    func didTapSaveButton(for cell: HomePostTableViewCell)
    
    func didTapLikeButton(for cell: HomePostTableViewCell)
    
    func didTapShareButton(for cell: HomePostTableViewCell)
    
    func didTapCommentButton(for cell: HomePostTableViewCell)
    
}
