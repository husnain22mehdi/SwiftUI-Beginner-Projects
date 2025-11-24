import Foundation
import TensorFlowLite
import AVFoundation
import CoreImage
import UIKit

final class FingerDetector {
    private var interpreter: Interpreter
    private let inputWidth = 512
    private let inputHeight = 512
    private let inputChannels = 3
    private let queue = DispatchQueue(label: "tflite.inference.queue")
    private let ciContext = CIContext()

    init?(modelName: String) {
        guard let modelPath = Bundle.main.path(forResource: modelName, ofType: "tflite") else {
            print("Model not found in bundle.")
            return nil
        }
        do {
            var options = Interpreter.Options()
            options.threadCount = 2
            interpreter = try Interpreter(modelPath: modelPath, options: options)
            try interpreter.allocateTensors()
        } catch {
            print("Failed to create interpreter: \(error)")
            return nil
        }
    }

    // Public inference API. Runs asynchronously and calls completion on main queue with parsed detections.
    func detectFingers(on sampleBuffer: CMSampleBuffer, completion: @escaping ([Detection]) -> Void) {
        queue.async { [weak self] in
            guard let self = self,
                  let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            // 1) Resize & convert to RGB uint8 buffer
            guard let rgbData = self.rgbDataFromPixelBuffer(pixelBuffer,
                                                            width: self.inputWidth,
                                                            height: self.inputHeight) else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                // Set input tensor (uint8)
                let inputTensor = try self.interpreter.input(at: 0)
                // If model expects uint8, set input data directly
                try self.interpreter.copy(rgbData, toInputAt: 0)
                // Invoke interpreter
                try self.interpreter.invoke()

                // Read outputs
                // Output indices / types depend on model. We'll attempt to read the typical ones:
                let bboxTensor = try self.interpreter.output(at: 0) // float32 [1,40,4]
                let classesTensor = try self.interpreter.output(at: 1) // float32 [1,40]
                let scoresTensor = try self.interpreter.output(at: 2) // float32 [1,40]
                let numDetectionsTensor = try self.interpreter.output(at: 3) // float32 [1]

                // Parse them
                let numDetections = Int((numDetectionsTensor.data.toArray(type: Float32.self).first ?? 0).rounded(.towardZero))
                let bboxArray = bboxTensor.data.toArray(type: Float32.self) // length = 1*40*4
                let classesArray = classesTensor.data.toArray(type: Float32.self) // length =1*40
                let scoresArray = scoresTensor.data.toArray(type: Float32.self)

                var detections: [Detection] = []
                let maxDetections = min(numDetections, 40)
                for i in 0..<maxDetections {
                    let score = scoresArray[i]
                    if score < 0.3 { continue } // threshold, tune as needed
                    let cls = Int(classesArray[i])
                    let base = i * 4
                    // Assuming bbox format = [ymin, xmin, ymax, xmax] normalized 0..1
                    let ymin = bboxArray[base + 0]
                    let xmin = bboxArray[base + 1]
                    let ymax = bboxArray[base + 2]
                    let xmax = bboxArray[base + 3]
                    let bbox = CGRect(x: CGFloat(xmin),
                                      y: CGFloat(ymin),
                                      width: CGFloat(xmax - xmin),
                                      height: CGFloat(ymax - ymin))
                    let det = Detection(bboxNormalized: bbox, score: Double(score), label: "\(cls)")
                    detections.append(det)
                }

                DispatchQueue.main.async {
                    completion(detections)
                }
            } catch {
                print("TFLite error: \(error)")
                DispatchQueue.main.async { completion([]) }
            }
        }
    }

    // Convert CVPixelBuffer to uint8 RGB Data resized to target
    private func rgbDataFromPixelBuffer(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> Data? {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        // Create CIImage from pixelBuffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // Create CGImage at required size using CIContext (will perform scaling)
        let sx = CGFloat(width)
        let sy = CGFloat(height)
        let extent = CGRect(x: 0, y: 0, width: sx, height: sy)

        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }

        // Draw cgImage into a RGB buffer of desired size
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4 // RGBA in CGContext -> we'll strip alpha
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }

        // Draw scaled
        context.draw(cgImage, in: extent)

        guard let data = context.data else { return nil }

        // The context buffer is BGRA or RGBA depending on platform. We'll assume RGBA (premultipliedLast).
        // We need RGB uint8 ordered as R,G,B...
        let pixelBufferPtr = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        var rgb = Data(capacity: width * height * 3)
        for i in 0..<(width * height) {
            let base = i * bytesPerPixel
            let r = pixelBufferPtr[base + 0]
            let g = pixelBufferPtr[base + 1]
            let b = pixelBufferPtr[base + 2]
            // If ordering differs (e.g., BGRA), swap accordingly. Test with your device.
            rgb.append(contentsOf: [r, g, b])
        }
        return rgb
    }
}

// A simple detection struct to pass to UI
struct Detection {
    // bboxNormalized is in (x,y,width,height) with x,y relative to model input (0..1).
    // Here bboxNormalized origin is top-left.
    let bboxNormalized: CGRect
    let score: Double
    let label: String
}

// Helper: convert Data of typed floats to array
fileprivate extension Data {
    func toArray<T>(type: T.Type) -> [T] where T: Numeric {
        let count = self.count / MemoryLayout<T>.size
        return self.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> [T] in
            let buffer = ptr.bindMemory(to: T.self)
            return Array(buffer.prefix(count))
        }
    }
}
