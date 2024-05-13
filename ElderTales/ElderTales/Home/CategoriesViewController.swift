//
//  CategoriesViewController.swift
//  ElderTales
//
//  Created by student on 06/05/24.
//

import UIKit

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: CategoriesViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataController.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryMainCell", for: indexPath) as! CategoriesCollectionViewCell
        let category = dataController.categories[indexPath.row]

        cell.categoryNameLabel.text = category.title
        print(category.image)
        cell.categoryImage.image = dataController.fetchImage(imagePath: category.image) ?? UIImage(systemName: "apple.terminal")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
        let category = dataController.categories.first(where: {$0.title == cell.categoryNameLabel.text})
        
        delegate?.categoryViewController(self, didSelectCategory: category!)
            dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "categoryCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "categoryMainCell")
    }
    
    
    private func configureCollectionViewLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
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



    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


protocol CategoriesViewControllerDelegate: AnyObject {
    func categoryViewController(_ controller: CategoriesViewController, didSelectCategory category: Category)
}


