import SwiftUI
import Vision
import VisionKit
import AVFoundation

struct CardScannerView: UIViewControllerRepresentable {
    
    @Binding var cardImage : UIImage?
    @Binding var showScanner : Bool
    
//    var onSuccess: (UIImage)
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [], // No auto recognition — just live camera
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: false
        )
        context.coordinator.scannerVC = scanner
        scanner.delegate = context.coordinator
        
        // Add a capture button on top of camera
        let captureButton = UIButton(type: .system)
        captureButton.setTitle("Capture", for: .normal)
        captureButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.layer.cornerRadius = 25
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(context.coordinator, action: #selector(Coordinator.captureImage), for: .touchUpInside)
        
        scanner.view.addSubview(captureButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: scanner.view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: scanner.view.bottomAnchor, constant: -50),
            captureButton.widthAnchor.constraint(equalToConstant: 120),
            captureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if !uiViewController.isScanning {
            try? uiViewController.startScanning()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: CardScannerView
        var scannerVC : DataScannerViewController?
        
        init(parent: CardScannerView) {
            self.parent = parent
        }
        
        // MARK: - Manual Capture
        @objc func captureImage() {
            guard let scannerVC = scannerVC else { return }
            guard let image = snapshot(view: scannerVC.view) else { return }
            
            // Detect and crop rectangle from the image
            detectCard(in: image) { croppedCard in
                DispatchQueue.main.async {
                    print("i am in detect card")
//                    print(croppedCard)
                    self.parent.cardImage = croppedCard ?? image
                    self.parent.showScanner = false
                }
            }
        }
        
        private func findScannerVC() -> UIViewController? {
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
                .first
        }
        
        // MARK: - Vision Rectangle Detection
        private func detectCard(in image: UIImage, completion: @escaping (UIImage?) -> Void) {
            guard let cgImage = image.cgImage else { completion(nil); return }
            
            let request = VNDetectRectanglesRequest { request, _ in
                guard let results = request.results as? [VNRectangleObservation],
                      let rect = results.first else {
                    completion(nil)
                    return
                }
                
                // Crop the card region
                let cropped = self.crop(image: image, to: rect)
                print("image cropped")
                completion(cropped)
            }
            
            request.minimumAspectRatio = 0.4
            request.maximumAspectRatio = 1.6
            request.minimumConfidence = 0.7
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
        
        private func crop(image: UIImage, to rect: VNRectangleObservation) -> UIImage? {
            guard let cgImage = image.cgImage else { return nil }
            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)
            
            // VNRectangleObservation uses normalized coordinates (0-1)
            let boundingBox = rect.boundingBox
            let x = boundingBox.origin.x * width
            let y = (1 - boundingBox.origin.y - boundingBox.size.height) * height
            let w = boundingBox.size.width * width
            let h = boundingBox.size.height * height
            
            guard let croppedCG = cgImage.cropping(to: CGRect(x: x, y: y, width: w, height: h)) else {
                return nil
            }
            
            return UIImage(cgImage: croppedCG, scale: image.scale, orientation: image.imageOrientation)
        }
        
        private func snapshot(view: UIView) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
            return renderer.image { context in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
    }
}
