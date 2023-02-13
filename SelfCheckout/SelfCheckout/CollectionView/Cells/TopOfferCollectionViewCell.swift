//
//  TopOfferCollectionViewCell.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 08/02/23.
//

import Foundation
import UIKit

class TopOfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productOfferImage: UIImageView!
    
    func updateOffer(bannerImage: UIImage) {
       
        productOfferImage.image = bannerImage
    }
    
}
