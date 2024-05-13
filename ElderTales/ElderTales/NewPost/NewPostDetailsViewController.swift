//
//  NewPostDetailsViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit
import AVFoundation


class NewPostDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataController.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoriesCollectionViewCell
        let category = dataController.categories[indexPath.row]
       
        cell.categoryImage.image = UIImage(contentsOfFile: category.image) ?? UIImage(named: category.image) ?? UIImage(systemName: "person.circle.fill")
        
        cell.categoryNameLabel.text = category.title
        return cell
    }
    
    var selectedCategory:String?

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
        self.selectedCategory = cell.categoryNameLabel.text

        // Highlight the selected cell
        cell.backgroundColor = UIColor.systemBlue // Change color to indicate selection
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.white.cgColor

        // Optionally reset other cells to their default appearance
//        for cell in collectionView.visibleCells as! [CategoriesCollectionViewCell] {
//            if cell != collectionView.cellForItem(at: indexPath) {
//                cell.backgroundColor = UIColor.clear // Or your default color
//                cell.layer.borderWidth = 0
//            }
//        }

        // Refresh the collectionView or perform necessary updates
        collectionView.reloadData()
    }

    
    var postURL:URL? = nil
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?

    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayer()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        configureCollectionViewLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false // Prevent the gesture from blocking other touch events
            view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                let adjustmentHeight = keyboardSize.height - (view.frame.height - titleText.frame.origin.y - titleText.frame.height)
                if adjustmentHeight > 0 {
                    view.frame.origin.y -= adjustmentHeight
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    private func configureCollectionViewLayout() {
        categoryCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // Define the size for each item
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(110))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            // Define the size for the group. We use .estimated here for height to accommodate various device orientations and sizes.
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(260))
            // Create a horizontal group to line up items in a row.
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Define the section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15)

            return section
        }
    }

    
    func setupVideoPlayer() {
        guard let videoURL = postURL else {
            print("Video URL is not set")
            return
        }

        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = .resizeAspect // Adjust the video to fit within the bounds
        videoView.layer.addSublayer(playerLayer!)
        player?.play()

        // Ensure the layer aligns with the orientation of the video content
//        if let track = AVAsset(url: videoURL).tracks(withMediaType: .video).first {
//            let size = track.naturalSize
//            let transform = track.preferredTransform
//            if (size.width == transform.tx && size.height == transform.ty) {
//                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: .pi))
//            } else if (transform.tx == 0 && transform.ty == 0) {
//                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: 0))
//            } else if (transform.tx == 0 && transform.ty == size.width) {
//                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: .pi/2))
//            } else {
//                playerLayer?.setAffineTransform(CGAffineTransform(rotationAngle: -.pi/2))
//            }
//        }
    }

    func createAndAddNewPost() {
        let title = titleText.text ??  "NoTitle"
        let coverImage = UIImage(named: "youngster")! // Make sure this exists in your assets
        let videoLink = postURL?.absoluteString ?? ""
        let hasVideo = true

        let newPost = Post(
            postedBy: dataController.currentUser!.id,
            length: 120,
            title: title,
            cover: "youngster",
            link: videoLink,
            hasVideo: hasVideo,
            suitableCategories: selectedCategory
        )
        dataController.addNewPost(post: newPost)
        print("podt added: \(newPost.title)")
        
    }
    
    @IBAction func postTapped(_ sender: Any) {
        createAndAddNewPost()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
