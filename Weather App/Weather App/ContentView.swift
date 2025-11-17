//
//  ContentView.swift
//  Weather App
//
//  Created by Husnain on 20/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Islamabad, PK")
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding(.bottom)
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
