//
//  EditProfileTableViewCell.swift
//  ElderTales
//
//  Created by student on 10/05/24.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
