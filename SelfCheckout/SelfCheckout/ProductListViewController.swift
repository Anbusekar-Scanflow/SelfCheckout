//
//  ProductListViewController.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 09/02/23.
//

import Foundation
import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var productCategoryList: UICollectionView!
    
    // MARK: App Lifecycle methods
    
    override func viewDidLoad() {
        
    }
    
}


extension ProductListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
        cell.updateProductCategory(image: CategoryDetails[indexPath.row].image, title: CategoryDetails[indexPath.row].title)
        return cell
    }
    
}
