//
//  ViewController.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 07/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var productsCategoryCollectionView: UICollectionView!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    

    // MARK: App Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        
        //productsCategoryCollectionView Delegate & Datasource
        productsCategoryCollectionView.delegate = self
        productsCategoryCollectionView.dataSource = self
        
    }


}


//MARK: Collection View Datasource

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
        cell.updateProductCategory(image: CategoryDetails[indexPath.row].image, title: CategoryDetails[indexPath.row].title)
        return cell
    }
    
}
