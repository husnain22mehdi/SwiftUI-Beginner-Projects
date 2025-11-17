//
//  ContentView.swift
//  CardScanner
//
//  Created by Husnain on 10/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showScanner = false
    @State private var cardImgaqe : UIImage?
//    @State private var originalImage : UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            if let img = cardImgaqe ?? UIImage(systemName: "photo")
//               let originalImg = originalImage
            {
//                Image(uiImage: originalImg)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxHeight: 300)
//                    .background(Color(.systemGray2))
//                    .border(Color.white)
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .background(Color(.systemGray2))
                    .border(Color.white)
            }
            Button("Scan Card"){
                showScanner = true
            }
        }
        .sheet(isPresented: $showScanner){
//            CardScannerView(onSuccess: { croppedImg, originalImg in
//                self.cardImgaqe = croppedImg
//                self.originalImage = originalImg
//            }, onCancel: {})
            CardScannerView(cardImage: $cardImgaqe, showScanner: $showScanner)
        }
    }
}
