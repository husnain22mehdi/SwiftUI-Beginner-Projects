import SwiftUI
import Vision


struct ContentView: View {
    @State private var inputImage: UIImage?
    @State private var detectedFaces: [VNFaceObservation] = []
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            if let image = inputImage {
                GeometryReader { geometry in
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        
                        // Draw rectangles over detected faces
                        ForEach(detectedFaces, id: \.uuid) { face in
                            let boundingBox = face.boundingBox
                            let x = boundingBox.origin.x * geometry.size.width
                            let y = (1 - boundingBox.origin.y - boundingBox.height) * geometry.size.height
                            let width = boundingBox.width * geometry.size.width
                            let height = boundingBox.height * geometry.size.height
                            
                            Rectangle()
                                .stroke(Color.red, lineWidth: 2)
                                .frame(width: width, height: height)
                                .position(x: x + width/2, y: y + height/2)
                        }
                    }
                }
                .frame(height: 400)
            } else {
                Text("No Image Selected")
                    .foregroundColor(.gray)
                    .frame(height: 400)
            }
            
            Button("Select Image") {
                showImagePicker = true
            }
            .padding()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage, completion: detectFaces)
        }
    }
    
    // 3️⃣ Vision face detection
    func detectFaces(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectFaceRectanglesRequest { request, error in
            if let results = request.results as? [VNFaceObservation] {
                DispatchQueue.main.async {
                    self.detectedFaces = results
                }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform face detection: \(error)")
            }
        }
    }
}
