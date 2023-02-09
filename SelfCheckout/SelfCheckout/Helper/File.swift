//
//  File.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 07/02/23.
//

import Foundation
import UIKit

struct ProductCategory {
    let title: String
    let image: UIImage
}

let CategoryDetails: [ProductCategory] = [
    ProductCategory(title: "Grocery", image: UIImage(named: "Grocessary") ?? UIImage()),
    ProductCategory(title: "Dairy Product", image: UIImage(named: "dairy") ?? UIImage()),
    ProductCategory(title: "Snacks", image: UIImage(named: "snacks") ?? UIImage()),
    ProductCategory(title: "Baby Products", image: UIImage(named: "baby") ?? UIImage()),
    ProductCategory(title: "Appliances", image: UIImage(named: "Appliances") ?? UIImage()),
    ProductCategory(title: "Electronics", image: UIImage(named: "Electronics") ?? UIImage()),
    ProductCategory(title: "Fashion", image: UIImage(named: "fashion") ?? UIImage()),
    ProductCategory(title: "Home", image: UIImage(named: "home") ?? UIImage()),
    ProductCategory(title: "Mobiles", image: UIImage(named: "Mobiles") ?? UIImage()),
    ProductCategory(title: "Baby Products", image: UIImage(named: "baby") ?? UIImage()),
    ProductCategory(title: "Appliances", image: UIImage(named: "Appliances") ?? UIImage()),
    ProductCategory(title: "Electronics", image: UIImage(named: "Electronics") ?? UIImage()),
    ProductCategory(title: "Fashion", image: UIImage(named: "fashion") ?? UIImage())
    
]
