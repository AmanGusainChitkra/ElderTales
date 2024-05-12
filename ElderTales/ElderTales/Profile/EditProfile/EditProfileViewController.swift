//
//  EditProfileViewController.swift
//  ElderTales
//
//  Created by student on 10/05/24.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userId:String = ""
    var userIndex:Int?
    var sections:[String] = ["nameCell", "usernameCell", "bioCell"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editTableView.dequeueReusableCell(withIdentifier: sections[indexPath.row], for: indexPath) as! EditProfileTableViewCell
        switch indexPath.row{
        case 0:
            cell.nameTextField.text = users[self.userIndex!].name
        case 1:
            cell.usernameTextField.text = users[self.userIndex!].email
        case 2:
            cell.bioTextField.text = users[self.userIndex!].description
        default:
            print("invalid")
        }
        return cell
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTableView.dataSource = self
        guard let userIndex = users.firstIndex(where: {$0.id == userId}) else { return }
        self.userIndex = userIndex
        let user = users[userIndex]
        self.profileImage.image = user.image
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        
    }
    
    
    @IBAction func didTapEditProfile(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Edit Profile Picture", message: "Choose a source", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            }))
        }

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // For iPad: to prevent crashing on iPad
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.allowsEditing = true  // if you want to allow editing
        present(imagePicker, animated: true)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            if let userIndex = users.firstIndex(where: {$0.id == userId}){
                self.profileImage.image = editedImage
            }
        } else if let originalImage = info[.originalImage] as? UIImage {
            // Use the original image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapSave(_ sender: Any) {
        // Assuming 'users' is an array of a user struct that is accessible in this context
        
        guard let userIndex = userIndex else { return }
        
        // Retrieve data from cells
        let nameCell = editTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditProfileTableViewCell
        let usernameCell = editTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditProfileTableViewCell
        let bioCell = editTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditProfileTableViewCell
        
        if nameCell?.nameTextField.text?.isEmpty ?? true || usernameCell?.usernameTextField.text?.isEmpty ?? true {
            // Alert the user that they need to fill out all fields
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Update the user in the array
        users[userIndex].name = nameCell?.nameTextField.text ?? ""
        users[userIndex].email = usernameCell?.usernameTextField.text ?? ""
        users[userIndex].description = bioCell?.bioTextField.text ?? ""
        users[userIndex].image = profileImage.image
        dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Saved", message: "Details updated successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
        

    }

    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
