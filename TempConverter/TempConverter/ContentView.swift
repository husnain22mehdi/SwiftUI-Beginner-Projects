//
//  ContentView.swift
//  TempConverter
//
//  Created by Husnain on 21/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
//    print(correctAnswer)
    
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var userScore  = 0
    
    var body: some View {
    
        ZStack{
            LinearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            VStack(spacing: 30){
                VStack{
                    Text("Guess the flag: ")
                    Text(countries[correctAnswer])
                        .font(.largeTitle.bold())
                    
                }
                ForEach(0..<3){ number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                    }.clipShape(.capsule)
                }
                VStack{
                    Text("Score: \(userScore)")
                }
            }.frame(maxWidth: .infinity)
            .background(.regularMaterial)
    
        }.alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }message: {
            Text("Your score is \(userScore)")
        }
        
    }
    
    func flagTapped(_ number : Int) {
//        print(correctAnswer)
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
//            print(scoreTitle)
        }else{
            scoreTitle = "Wrong"
            userScore = 0
//            print(scoreTitle)
        }
        showingScore = true
//        print(showingScore)
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

}

#Preview {
    ContentView()
}
