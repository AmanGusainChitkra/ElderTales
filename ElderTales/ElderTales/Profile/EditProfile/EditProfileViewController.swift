//
//  EditProfileViewController.swift
//  ElderTales
//
//  Created by student on 10/05/24.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource {
    var userId:String = ""
    var sections:[String] = ["nameCell", "usernameCell", "bioCell"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editTableView.dequeueReusableCell(withIdentifier: sections[indexPath.row], for: indexPath)
        return cell
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        editTableView.dataSource = self
        guard let user = users.first(where: {$0.id == userId}) else { return }
        
        self.profileImage.image = user.image
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
    }

}
