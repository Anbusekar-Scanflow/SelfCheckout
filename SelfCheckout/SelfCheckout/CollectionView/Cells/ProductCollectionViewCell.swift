//
//  ProductCollectionViewCell.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 10/02/23.
//

import Foundation
import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    func updateProduct(name: String, image: UIImage) {
        productImage.image = image
        productName.text = name
    }
}
