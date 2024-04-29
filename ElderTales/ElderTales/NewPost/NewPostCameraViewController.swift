////
////  NewPostCameraViewController.swift
////  ElderTales
////
////  Created by student on 26/04/24.
////
//
//import UIKit
//
//class NewPostCameraViewController: UIViewController {
//
//    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var button: UIButton!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        imageView.backgroundColor = .secondarySystemBackground
//        
//       //button.backgroundColor = .systemBlue
//      //button.setTitle("Take Picture", for: .normal)
//        //button.setTitleColor(.white, for: .normal)
//
//        // Do any additional setup after loading the view.
//    }
//    
//    @IBAction func button(_ sender: UIButton) {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = self
//        present(picker, animated: true)
//    }
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//extension cameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
//            return
//        }
//        imageView.image = image
//    }
//
//}
