//
//  categoriesViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit

class categoriesViewController: UIViewController {

   
 
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    var categories :[String] = [ "Science", "Business", "Horror", "Relationship", "Spiritual"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.dataSource = self

                    
    }
}

extension categoriesViewController:

    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
    Int{
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->

    UICollectionViewCell {

    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
 as! categoriesCollectionViewCell

    cell.layer.borderWidth = 1

    cell.layer.cornerRadius = 20
        cell.layer.borderColor = UIColor.blue.cgColor
        
 
    cell.Titlelbl.text = categories [indexPath.row]

    cell.CategoryImg.image = UIImage(named: categories[indexPath.row])
        

    return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:

                        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

    let size = (collectionView.frame.size.width-10)/2



    return CGSize(width: size, height: size)
    }

}
