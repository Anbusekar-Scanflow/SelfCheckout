//
//  ScanningViewController.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 13/02/23.
//

import Foundation
import ScanflowCore
import ScanflowBarcode
import UIKit
import ARKit
import RealityKit
import UIKit.UIGestureRecognizerSubclass
import NaturalLanguage
import Vision
import VisionKit
import VideoToolbox
import AVFoundation


extension UIColor {
    @nonobjc class var appDarkBlack: UIColor {
        return UIColor(hexString: "#0F0E13")
    }
    @nonobjc class var primaryColor: UIColor {
        return UIColor(hexString: "#0C54C5")
    }
    @nonobjc class var blackColor: UIColor {
        return UIColor(hexString: "#000000")
    }
    @nonobjc class var lightGrayColor: UIColor {
        return UIColor(hexString: "#9B9B9C")
    }
    @nonobjc class var topLeftArrowColor: UIColor {
        return UIColor(hexString: "#FF543E")
    }
    @nonobjc class var bottomLeftArrowColor: UIColor {
        return UIColor(hexString: "#356DC0")
    }
    @nonobjc class var topRightArrowColor: UIColor {
        return UIColor(hexString: "#3869E8")
    }
    @nonobjc class var bottomRightArrowColor: UIColor {
        return UIColor(hexString: "#FFAF4D")
    }
}


class ScanningViewController: UIViewController, ResultViewProtocol {
    
    func closeAction() {
        self.scanFlowARManager?.pauseScanflowMeasure()
    }
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var organicButton: UIButton!
    @IBOutlet weak var glutenFreeButton: UIButton!
    @IBOutlet weak var filterViewWidth: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    
    
    public var scannerType: ScannerType = .batchInventry
    
    private var inputDelegate: ResultInputProtocol?
    private var isFilterExpand: Bool = false
    private var isProductViewShown: Bool = false
        
//    private lazy var Scansdd = ScanflowBarcodeARManager()
    private lazy var scanFlowARManager:ScanflowBarCodeARManager? = ScanflowBarCodeARManager(previewView: previewView, scannerType: scannerType.rawValue, overCropNeed: false, overlayApperance: .square, leftTopArc: .topLeftArrowColor, leftDownArc: .bottomLeftArrowColor, rightTopArc: .topRightArrowColor, rightDownArc: .bottomRightArrowColor)
    
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: { (request, error) in
            guard error == nil else {
                self.showAlert(withTitle: "Barcode Error", message: error!.localizedDescription)
                return
            }

            self.processClassification(for: request)
        })
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanFlowARManager?.validateLicense(authKey: "b2002a0ee02af9f40f00bf8a42c2b4c8b8a166ea")
        scanFlowARManager?.delegate = self
        scanFlowARManager?.toBeSendInDelegate = false
        scanFlowARManager?.configureScanflowMeasure()
        self.filterViewWidth.constant = 0
        filterView.clipsToBounds = true
        filterView.layer.cornerRadius = 25
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeAction()
        scanFlowARManager = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.filterViewWidth.constant = 0
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func organictapped(_ sender: Any) {
        filterButtonAction(sender)
    }
    
    @IBAction func glutenButtonTapped(_ sender: Any) {
        filterButtonAction(sender)
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 3, delay: 2, options: .curveEaseOut, animations: { () -> Void in
            self.filterViewWidth.constant = self.isFilterExpand == false ? (self.previewView.frame.width * 0.85) : 0
        }, completion: { (finished: Bool) -> Void in
            self.filterButton.setImage(UIImage(named: self.isFilterExpand == false ? "filter Close Button": "Filter"), for: .normal)
            self.isFilterExpand = !self.isFilterExpand
        })
    }
    
    // MARK: - Navigation
    class func initWithStory() -> ScanningViewController? {
        let vc = UIStoryboard(name: Stoyboard.main, bundle: nil).instantiateViewController(withIdentifier: "ScanningViewController") as? ScanningViewController
        return vc
    }    
    
    private func productDetailsView() -> UIView? {
        let productView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: (previewView.frame.width * 0.80), height: (previewView.frame.height * 0.35))))
        let productImage = UIImage(named: "productDetails")
        let productImageView = UIImageView(image: productImage)
        productImageView.frame = productView.frame
        productView.addSubview(productImageView)
        let addCartButton = UIButton(frame: productView.frame)
        addCartButton.titleLabel?.isHidden = true
        addCartButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        return productView
    }
    
    @objc addCard
}

extension ScanningViewController: ScanflowCameraManagerDelegate {
    func capturedOutput(result: String, codeType: String, results: [String]?, processedImage: UIImage?, position: CGRect) {
        print(result)
    }
    
    func advancedAROverlay(result: String, codeType: String, results: [String]?, processedImage: UIImage?, inferences: [ScanflowCore.Inference]) -> ScanflowCore.TrackedOverlayView? {
        for infer in inferences {
            let threshold = infer.boundingRect.width
            print(threshold)
            
            var productView = threshold < 120 ? organic() : productDetailsView()
            if isProductViewShown == false &&  threshold > 120 {
                isProductViewShown = true
                scanFlowARManager?.resetARViews()
                print("ARView reset")
            }
            isProductViewShown = !(threshold < 120)
            if let popupview = productView {
                let arOverlay = TrackedOverlayView(overlay: popupview, resultString: result, inferences: inferences)
                return arOverlay
            }
        }
        return nil
    }
    
    
    func updatePopView()  -> UIView! {
        let popView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 260))
        popView.layer.masksToBounds = true
        popView.layer.cornerRadius = 10
        popView.backgroundColor = .white
        let productNameLabel = UILabel(frame: CGRect(x: 0, y: 5, width: 260, height: 20))
        productNameLabel.textAlignment = .center
        productNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        productNameLabel.text = "Airpod"
        popView.addSubview(productNameLabel)
        
        let prodcutImage = UIImageView(frame: CGRect(x: 0, y: 30, width: 260, height: 200))
        prodcutImage.image = UIImage(named: "AirPods")
        prodcutImage.contentMode = .scaleAspectFit
        popView.addSubview(prodcutImage)
        
        let rattingLabel = UILabel(frame: CGRect(x: 0, y: 230, width: 260, height: 20))
        rattingLabel.text = "4.5"
        rattingLabel.textAlignment = .center
        rattingLabel.font = .systemFont(ofSize: 18.0, weight: .semibold)
        popView.addSubview(rattingLabel)
        
        return popView
    }
    
    func organic()  -> UIView! {
        let popView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        popView.layer.masksToBounds = true
        popView.layer.cornerRadius = 10
        popView.backgroundColor = .clear
        
        let prodcutImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        prodcutImage.image = UIImage(named: "organic")
        prodcutImage.contentMode = .scaleAspectFit
        popView.addSubview(prodcutImage)
        
        return popView
    }
    
    func newPopupScreen(_ decodedResult: String) -> UIView? {
        
        let popupView = AROverlayView.getNibView()
        if decodedResult == "ABC-abc-1234" {
            let productDetails = ProductDetails(name: "AirPods", imageName: "airpods", rating: "4.5")
            popupView?.populateViewForProduct(productDetails)   
        } else {
            let productDetails = ProductDetails(name: "Boat - AirDopes", imageName: "airdopes", rating: "4.1")
            popupView?.populateViewForProduct(productDetails)
        }
        popupView?.layer.cornerRadius = 20
        popupView?.layer.masksToBounds = true
        popupView?.tag = 121
        return popupView
    }

    
    func getCurrentDate() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let strDate = formatter.string(from: currentDate)
        return strDate
    }
    
    func needFlashLight(status: Bool) {
        print(status)
    }
    
    
    func capturedOutput(result: String, codeType: String, results: [String]?, processedImage: UIImage?) {
  
    }
    
    func presentCameraPermissionsDeniedAlert() {
        
    }
    
    func presentVideoConfigurationErrorAlert() {
        
    }
    
    func sessionRunTimeErrorOccurred() {
        
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        
    }
    
    func sessionInterruptionEnded() {
        
    }
    
    func captured(originalframe: CVPixelBuffer, overlayFrame: CGRect, croppedImage: UIImage) {
//        var codeTrack = CodeInfo()
//        self.scanFlowARManager.detectionClassiferHandler(originalframe,&codeTrack, previewSize: previewView.frame.size)
////        DispatchQueue.global(qos: .userInitiated).async {
////            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])
////
////            do {
////                try handler.perform([self.detectBarcodeRequest])
////            } catch {
////                self.showAlert(withTitle: "Error Decoding Barcode", message: error.localizedDescription)
////            }
////
////        }
        
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    
    
    func showAlert(title: String?, message: String) {
        
    }
    
    
    // MARK: - Vision
    func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
                let payload = bestResult.payloadStringValue {
                self.showInfo(for: payload)
            } else {
//                self.showAlert(withTitle: "Unable to extract results",
//                               message: "Cannot extract barcode information from data.")
            }
        }
    }
    
    private func showInfo(for payload: String) {
        if payload != "" {
            showAlert(withTitle: "Bar Code", message: payload)
        } else {
            showAlert(withTitle: "No Bar Code found for this payload", message: "")
        }
    }
    
}



extension UIColor {

    /// Coverting the hex string color code into 12 or 24 or 32 bit rgb color code
    /// - Parameter hexString: Hex color code string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let aValue, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (aValue, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (aValue, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (aValue, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (aValue, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(aValue) / 255)
    }
}


enum Stoyboard {
    static let main = "Main"
}

enum ScanFlow {
    static let appName = "Scanflow"
    static let bundleId = "com.obs.scanflow"
    static let platForm = "iOS"
}


extension CGImagePropertyOrientation {

    init(_ uiOrientation: UIImage.Orientation) {

        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
            @unknown default: fatalError()
        }
    }
}
extension UIImage.Orientation {

    init(_ cgOrientation: UIImage.Orientation) {

        switch cgOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
            @unknown default: fatalError()
        }
    }
}

extension CIImage {
    func toPixelBuffer(_ width: Int,_ height: Int) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            attrs,
                            &pixelBuffer)
        let context = CIContext()
        context.render(self, to: pixelBuffer!)
        return pixelBuffer
    }
}

extension UIView {
    func toSCNNode(position: CGRect) -> SCNNode? {
       
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { _ in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        
        let layer = CALayer()
        layer.contents = image.cgImage
        layer.bounds = CGRect(origin: .zero, size: self.bounds.size)
        layer.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
        let scene = SKScene(size: self.bounds.size)
        scene.backgroundColor = .clear
        scene.addChild(SKSpriteNode(texture: SKTexture(cgImage: image.cgImage!), size: scene.size))
        
        let material = SCNMaterial()
        material.diffuse.contents = scene
        
        let plane = SCNPlane(width: self.bounds.width / 100, height: self.bounds.height / 100) // Scale down the plane by 100 for better proportions
        plane.materials = [material]
        
        let node = SCNNode(geometry: plane)
        return node
    }
}
