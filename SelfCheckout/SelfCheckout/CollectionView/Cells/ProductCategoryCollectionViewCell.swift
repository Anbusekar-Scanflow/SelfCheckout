//
//  ProductCategoryCollectionViewCell.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 07/02/23.
//

import Foundation
import UIKit

class ProductCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    func updateProductCategory(image:UIImage, title:String) {
        productImage.image = image
        productTitle.text = title
    }
}
