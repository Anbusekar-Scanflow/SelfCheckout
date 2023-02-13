//
//  File.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 07/02/23.
//

import Foundation
import UIKit

struct Category {
    let title: String
    let image: UIImage
}

let CategoryDetails: [Category] = [
    Category(title: "Steak", image: UIImage(named: "steak") ?? UIImage()),
    Category(title: "Vegetables", image: UIImage(named: "vegetables") ?? UIImage()),
    Category(title: "Beverages", image: UIImage(named: "beverages") ?? UIImage()),
    Category(title: "Fish", image: UIImage(named: "fish") ?? UIImage()),
    Category(title: "Wine", image: UIImage(named: "wine") ?? UIImage())
]


let TodayOffers: [Category] = [
    Category(title: "", image: UIImage(named: "offer1") ?? UIImage()),
    Category(title: "", image: UIImage(named: "offer2") ?? UIImage()),
    Category(title: "", image: UIImage(named: "offer3") ?? UIImage()),
]

let TopCategory: [Category] = [
    Category(title: "Apparel", image: UIImage(named: "Apparel") ?? UIImage()),
    Category(title: "School", image: UIImage(named: "School") ?? UIImage()),
    Category(title: "Sports", image: UIImage(named: "Sports") ?? UIImage()),
    Category(title: "Electronic", image: UIImage(named: "Electronic") ?? UIImage()),
    Category(title: "All", image: UIImage(named: "All") ?? UIImage())
]


let ProductCategory: [Category] = [
    Category(title: "Top Picks", image: UIImage(named: "Top Picks") ?? UIImage()),
    Category(title: "Bread & Eggs", image: UIImage(named: "Bread & Eggs") ?? UIImage()),
    Category(title: "Packed Food", image: UIImage(named: "Packed Food") ?? UIImage()),
    Category(title: "Biscuit", image: UIImage(named: "Biscuit") ?? UIImage()),
    Category(title: "Pan Corner", image: UIImage(named: "Pan Corner") ?? UIImage()),
    Category(title: "Meat, Fish", image: UIImage(named: "Meat, Fish") ?? UIImage()),
    Category(title: "Cool Drinks", image: UIImage(named: "Cool Drinks") ?? UIImage()),
    Category(title: "Bread & Eggs", image: UIImage(named: "Bread & Eggs") ?? UIImage()),
    Category(title: "Packed Food", image: UIImage(named: "Packed Food") ?? UIImage()),
    Category(title: "Biscuit", image: UIImage(named: "Biscuit") ?? UIImage()),
    Category(title: "Pan Corner", image: UIImage(named: "Pan Corner") ?? UIImage()),
    Category(title: "Meat, Fish", image: UIImage(named: "Meat, Fish") ?? UIImage())
]

let Products: [Category] = [
    Category(title: "Cereal", image: UIImage(named: "Cereal") ?? UIImage()),
    Category(title: "Leimer", image: UIImage(named: "Leimer") ?? UIImage()),
    Category(title: "Pasta", image: UIImage(named: "Pasta") ?? UIImage()),
    Category(title: "Zucker", image: UIImage(named: "Zucker") ?? UIImage()),
    Category(title: "Speise starke", image: UIImage(named: "Speise starke") ?? UIImage()),
    Category(title: "Diamant", image: UIImage(named: "Diamant") ?? UIImage())
]
