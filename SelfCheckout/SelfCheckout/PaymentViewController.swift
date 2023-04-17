//
//  PaymentViewController.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 13/04/23.
//

import Foundation
import UIKit

class PaymentViewController: UIViewController {
  
    @IBOutlet weak var productTableView: UITableView!
    // MARK: App Lifecycle methods
    @IBOutlet weak var productTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.delegate = self
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
        //productsCategoryCollectionView Delegate & Datasource
        
    }
    
}


extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let productCell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as? ProductListTableViewCell {
            return productCell
        }
        return UITableViewCell()
    }
    
    
    
}
