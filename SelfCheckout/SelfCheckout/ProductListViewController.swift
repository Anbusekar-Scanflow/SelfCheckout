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
        return collectionView == productCategoryList ? ProductCategory.count : Products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCategoryList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
            cell.updateProductCategory(image: ProductCategory[indexPath.row].image, title: ProductCategory[indexPath.row].title)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
            cell.updateProduct(name: Products[indexPath.row].title, image: Products[indexPath.row].image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanningViewController") as? ScanningViewController {
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
}
