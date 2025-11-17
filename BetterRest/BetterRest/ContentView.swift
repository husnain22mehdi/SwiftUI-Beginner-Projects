//
//  ContentView.swift
//  BetterRest
//
//  Created by Husnain on 23/10/2025.
//

import SwiftUI
//import CoreML

struct ContentView: View {
    
    @State private var selectTable = 2
    @State private var totalQuestions = 0
    @State private var questionsArray = [String]()
    @State private var gameIsActive = false
//    @State private var showStartButton = true
    
    private var totalQuestionsArray  = [5, 10, 20]
    
    var body: some View {
            
        NavigationStack{
            ZStack{
                
                LinearGradient(colors: [.orange, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack{
                    
                    VStack(alignment: .leading){
                        Text("Pick Table:")
                            .font(.headline)
                        
                        Stepper("\(selectTable)", value: $selectTable, in: 2...12)
                        
                        
                        Text("Total Questions:")
                            .font(.headline)
                        
                        Picker("Total Questions:", selection: $totalQuestions){
                            ForEach(totalQuestionsArray, id: \.self){
                                Text("\($0)")
                            }
                        }.pickerStyle(.segmented)
                    }
                    Spacer()
                    
                    
                    Button("Start Game", action: startGame)
                        .frame(width: 150, height: 70, alignment: .center)
                        .background(.white)
                        .foregroundStyle(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    
                    
                    Spacer()
                    
                }.navigationTitle("Edutainment")
                    .padding()
                
            }
        }
        
    }
    
    func generateQuestions(){
        
        for _ in (0..<totalQuestions){
            let num = Int.random(in: 0...10)
            questionsArray.append("\(selectTable) * \(num) = ??")
        }
    }
    
    func startGame(){
        generateQuestions()
        print(questionsArray)
        print(questionsArray.count)
    }
}
 
#Preview {
    ContentView()
}
