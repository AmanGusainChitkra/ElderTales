//
//  categoriesViewController.swift
//  ElderTales
//
//  Created by student on 01/05/24.
//

import UIKit

class categoriesViewController: UIViewController {

   
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        var _ :[String] = [ "Science", "Business", "Horror", "Relationship", "Spiritual"]
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
