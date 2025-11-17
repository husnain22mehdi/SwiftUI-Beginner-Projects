//
//  ContentView.swift
//  BarcodeScanner
//
//  Created by Husnain on 04/11/2025.
//

import SwiftUI

struct AlertItem : Identifiable {
    let id = UUID()
    let title : String
    let message : String
    let dismissButton : Alert.Button
}

struct AlertContext {
    
    static let invalidDeviceInput = AlertItem(title: "Invalid Device Input", message: "Something is wrong with the camera. We are unable to catch the input.", dismissButton: .default(Text("OK"), action: {}))
    
    static let invalidScannedValue = AlertItem(title: "Invalid Scanned Value", message: "The value scanned is not valid. This app scans EAN-8 and EAN-13", dismissButton: .default(Text("OK"), action: {}))
}

struct BarcodeScannerView: View {
    
    @State private var scannedCode = ""
    @State private var alertItem : AlertItem?
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(){
                Text("Barcode Scanner")
                    .font(.system(size: 40).bold())
            }
            .padding(.leading)
            .offset(y: -25)
//            .frame(maxWidth: .infinity, maxHeight: 100 ,alignment: .topLeading)
//            .border(.red)
            Spacer()
            ScannerView(scannedCode: $scannedCode, alertItem: $alertItem)
                .frame(maxWidth: .infinity, maxHeight: 350)
//                .background(.black.opacity(0.8))
            Spacer()
            VStack(spacing: 10){
                HStack{
                    Image(systemName: "barcode.viewfinder")
                    Text("Scanned Barcode:")
                }.font(.system(size: 25))
                Text(scannedCode.isEmpty ? "Not Yet Scanned" : scannedCode)
                    .font(.system(size: 32).bold())
                    .foregroundStyle(scannedCode.isEmpty ? .red : .green)
                    .offset(x: 4)
            }
            .padding(.leading, 70)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .border(.blue)
        .alert(item: $alertItem) { alertItem in
            Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
        }
    }
}

#Preview {
    BarcodeScannerView()
}
