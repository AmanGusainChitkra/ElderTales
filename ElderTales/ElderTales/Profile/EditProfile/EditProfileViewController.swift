//
//  EditProfileViewController.swift
//  ElderTales
//
//  Created by student on 10/05/24.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var userId:String = ""
    var user:User?
    var imagePath:String?
    var sections:[String] = ["nameCell", "usernameCell", "bioCell"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }
    
    var onDismiss: (() -> Void)?
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTableView.dataSource = self
        guard let user = dataController.fetchUser(userId: userId) else { return }
        self.user = user
        self.profileImage.image = dataController.fetchImage(imagePath: user.image) ?? UIImage(systemName: "person.circle.fill")
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
    
    deinit{
        onDismiss?()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = editTableView.dequeueReusableCell(withIdentifier: sections[indexPath.row], for: indexPath) as! EditProfileTableViewCell
        if let user = user{
            switch indexPath.row{
            case 0:
                cell.nameTextField.text = user.name
            case 1:
                cell.usernameTextField.text = user.email
            case 2:
                cell.bioTextField.text = user.description
            default:
                print("invalid")
            }
        }
        return cell
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.profileImage.image = editedImage
            saveImage(image: editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.profileImage.image = originalImage
            saveImage(image: originalImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    private func saveImage(image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("profile_image.jpg")
            try? data.write(to: filename)
            self.imagePath = filename.path
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    @IBAction func didTapSave(_ sender: Any) {
        let nameCell = editTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditProfileTableViewCell
        let emailCell = editTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditProfileTableViewCell
        let bioCell = editTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditProfileTableViewCell

        guard let newName = nameCell?.nameTextField.text,
              let newEmail = emailCell?.usernameTextField.text,
              !newName.isEmpty, !newEmail.isEmpty else {
            presentAlert(title: "Error", message: "Please fill out all fields.")
            return
        }

        let newDescription = bioCell?.bioTextField.text ?? ""
        let imagePath = self.imagePath ?? user?.image

        dataController.updateUserDetails(name: newName, email: newEmail, description: newDescription, imagePath: imagePath)
        
        presentAlert(title: "Saved", message: "Details updated successfully")
    }

    private func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // Pop the view controller
            self?.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }

    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
