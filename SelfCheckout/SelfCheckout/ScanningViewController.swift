//
//  ScanningViewController.swift
//  SelfCheckout
//
//  Created by Mac-OBS-46 on 13/02/23.
//

import Foundation
import UIKit
import ScanflowCore
import ScanflowBarcode
import Vision


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
    
    public var scannerType: ScannerType = .barcode
    
    private var inputDelegate: ResultInputProtocol?
    
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
    }
    
    // MARK: - Navigation
    class func initWithStory() -> ScanningViewController? {
        let vc = UIStoryboard(name: Stoyboard.main, bundle: nil).instantiateViewController(withIdentifier: "ScanningViewController") as? ScanningViewController
        return vc
    }
   
    
}

extension ScanningViewController: ScanflowCameraManagerDelegate {
    func advancedAROverlay(result: String, codeType: String, results: [String]?, processedImage: UIImage?, inferences: [ScanflowCore.Inference]) -> ScanflowCore.TrackedOverlayView? {
        if let popupview = newPopupScreen(result) {
            let arOverlay = TrackedOverlayView(overlay: popupview, resultString: result, inferences: inferences)
            return arOverlay
        } else {
            return nil
        }
    }
    
    
    func newPopupScreen(_ decodedResult: String) -> UIView? {
        
        let popupView = AROverlayView.getNibView()
        if decodedResult == "ABC-abc-1234" {
            let productDetails = ProductDetails(name: "AirPods", imageName: "airpods", rating: "4.5")
            popupView?.populateViewForProduct(productDetails)
        } else if decodedResult == "0725272730706"{
            let bloodSample = BloodSampleDetails(patientName: "Karthikeyan-A", bloodGroup: "B+", dateOfTest: self.getCurrentDate(), place: "Madurai")
            popupView?.populateViewForBloodSample(bloodSample)
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
