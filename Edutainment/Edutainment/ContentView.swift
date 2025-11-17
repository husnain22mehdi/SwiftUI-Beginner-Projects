//
//  ContentView.swift
//  Edutainment
//
//  Created by Husnain on 24/10/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var gameIsActive = false
    @State private var showResults = false
    @State private var questions = [Question]()
    @State private var currentQuestion = 0
    @State private var score = 0

    @State private var selectedTable = 2
    @State private var totalQuestions = 5
    @State private var userAnswer = ""

    var body: some View {
        NavigationStack {
            if gameIsActive && !showResults{
                VStack {
                    Text(questions[currentQuestion].text)
                        .font(.title)
                    
                    TextField("Your answer", text: $userAnswer)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    
                    Button("Submit") {
                        checkAnswer()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }else if !gameIsActive && showResults{
                
                VStack {
                    Text("Game Over!")
                        .font(.largeTitle)
                    Text("Your score: \(score)/\(questions.count)")
                        .font(.title2)
                    Button("Play Again") {
                        gameIsActive = false
                        showResults = false
                    }
                    .buttonStyle(.borderedProminent)
                }

            }
            
            else if !gameIsActive && !showResults{
                VStack {
                    Stepper("Up to \(selectedTable)", value: $selectedTable, in: 2...12)
                    Picker("Number of Questions", selection: $totalQuestions) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("20").tag(20)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    Button("Start Game") {
                        questions = generateQuestions(upTo: selectedTable, total: totalQuestions)
                        currentQuestion = 0
                        score = 0
                        gameIsActive = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    func generateQuestions(upTo table: Int, total: Int) -> [Question] {
        var questions = [Question]()

        for _ in 0..<total {
            let first = Int.random(in: 1...table)
            let second = Int.random(in: 1...12)
            let text = "What is \(first) × \(second)?"
            let answer = first * second
            questions.append(Question(text: text, answer: answer))
        }

        return questions
    }

    
    func checkAnswer() {
        let correct = questions[currentQuestion].answer
        if Int(userAnswer) == correct {
            score += 1
        }
        userAnswer = ""
        
        if currentQuestion + 1 < questions.count {
            currentQuestion += 1
        } else {
            gameIsActive = false // back to results/settings
            showResults = true
        }
    }

 
}

#Preview {
    ContentView()
}
