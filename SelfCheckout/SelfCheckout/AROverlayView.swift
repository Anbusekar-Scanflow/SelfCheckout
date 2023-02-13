//
//  AROverlayView.swift
//  ScanflowCore
//
//  Created by @karthi on 13/12/22.
//

import UIKit
import Foundation

class AROverlayView: UIView {
    
    @IBOutlet weak var parentView: UIView!
    
    
    @IBOutlet weak var productView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    
    
    @IBOutlet weak var bloodSampleView: UIView!
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var bloodGroup: UILabel!
    
    @IBOutlet weak var dateOfTest: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    
    @IBOutlet weak var downImage: UIImageView!
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func populateViewForProduct(_ productDetails: ProductDetails?) {
        parentView.layer.cornerRadius = 15
        productView.layer.cornerRadius = 15
        self.downImage.tintColor = .white
        if let details = productDetails {
            self.productView.isHidden = false
            self.bloodSampleView.isHidden = true
            productImage.image = UIImage(named: details.imageName)
            self.titleLabel.text = details.name
            self.ratingLabel.text = "Rating - \(details.rating)"
        }
    }
    
    public func populateViewForBloodSample(_ bloodSample: BloodSampleDetails?) {
        parentView.layer.cornerRadius = 15
        bloodSampleView.layer.cornerRadius = 15
        self.downImage.tintColor = .black
        if let details = bloodSample {
            self.bloodSampleView.isHidden = false
            self.productView.isHidden = true
            self.patientName.text = details.patientName
            self.bloodGroup.text = "Blood Group - \(details.bloodGroup)"
            self.dateOfTest.text = "Date - \(details.dateOfTest)"
            self.placeLabel.text = "Location - \(details.place)"
        }
    }
    
    class func getNibView() -> AROverlayView? {
        let nib = UINib(nibName: "AROverlayView", bundle: nil)
        let view = nib.instantiate(withOwner: self).first as? AROverlayView
        return view
    }
    
}

struct ProductDetails {
    let name: String
    let imageName: String
    let rating: String
}

struct BloodSampleDetails {
    let patientName: String
    let bloodGroup: String
    let dateOfTest: String
    let place: String
}
