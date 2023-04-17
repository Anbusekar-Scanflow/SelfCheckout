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
    
    @IBOutlet weak var todayOfferCollectionView: UICollectionView!
    
    @IBOutlet weak var homeTabBar: UITabBarItem!
    
    @IBOutlet weak var otherCategoryCollectionView: UICollectionView!
    
    var scrollCount: Int = 0
    
    // MARK: App Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //productsCategoryCollectionView Delegate & Datasource
        startTimer()
        
    }
    
    @IBAction func scaButtonTapped(_ sender: Any) {
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanningViewController") as? ScanningViewController {
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
    /**
     Scroll to Next Cell
     */
    @objc func scrollToNextCell() {
        
        //scroll to next cell
        todayOfferCollectionView.scrollToItem(at: IndexPath(row: scrollCount, section: 0), at: .left, animated: true)
        
        if scrollCount == 2 {
            scrollCount = 0
        } else {
            scrollCount += 1
        }
        
    }
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
        
        
    }
    
    func current(CollectionViewtype: UICollectionView) -> HomepageCollectionViewTypes {
        switch CollectionViewtype {
        case todayOfferCollectionView:
            return .TopOffer
        case productsCategoryCollectionView:
            return .TopCategory
        default:
            return .OtherCategory
        }
    }
    
}


//MARK: Collection View Datasource

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case productsCategoryCollectionView:
            return CategoryDetails.count
        case todayOfferCollectionView:
            return TodayOffers.count
        case otherCategoryCollectionView:
            return TopCategory.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if collectionView == productsCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
            cell.updateProductCategory(image: CategoryDetails[indexPath.row].image, title: CategoryDetails[indexPath.row].title)
            collectionViewCell = cell
        } else if collectionView ==  todayOfferCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopOfferCollectionViewCell", for: indexPath) as! TopOfferCollectionViewCell
            cell.updateOffer(bannerImage: TodayOffers[indexPath.row].image)
            collectionViewCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
            cell.updateProductCategory(image: TopCategory[indexPath.row].image, title: TopCategory[indexPath.row].title)
            collectionViewCell = cell
        }
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProductListViewController") as? ProductListViewController {
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    
}
