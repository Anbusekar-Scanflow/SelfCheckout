//
//  ProductListTableViewCell.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 13/04/23.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLable: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    private func updateProductImageApperance() {
        // assuming you have an imageView instance created already
        productImageView.layer.borderWidth = 2.0
        productImageView.layer.borderColor = UIColor.lightGray.cgColor
        productImageView.layer.cornerRadius = 5.0
        productImageView.clipsToBounds = true

    }
}
