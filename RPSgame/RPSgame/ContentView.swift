import SwiftUI

struct ContentView: View {
    private let moves = ["Rock", "Paper", "Scissors"]

    @State private var compChoice = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var round = 1
    @State private var showingResult = false
    @State private var resultTitle = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("Round \(round) / 10")
                            .font(.headline)
                        Text("Computer chose:")
                        Text(moves[compChoice])
                            .font(.largeTitle.bold())
                    }

                    Text("Your goal is to **\(shouldWin ? "WIN" : "LOSE")**")
                        .font(.title3)
                        .foregroundColor(shouldWin ? .green : .red)

                    HStack(spacing: 25) {
                        ForEach(0..<3) { number in
                            Button {
                                playerTapped(number)
                            } label: {
                                VStack {
                                    Image(systemName: symbol(for: moves[number]))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .padding()
                                    Text(moves[number])
                                        .font(.headline)
                                }
                                .frame(width: 110, height: 130)
                                .background(.white)
                                .cornerRadius(15)
                                .shadow(radius: 4)
                            }
                        }
                    }

                    Text("Score: \(score)")
                        .font(.title2.bold())
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Rock Paper Scissors")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                }
            }
            .alert(resultTitle, isPresented: $showingResult) {
                Button(round < 10 ? "Next Round" : "Restart", action: nextRound)
            } message: {
                Text("Your score is \(score)")
            }
        }
    }

    // MARK: - Game logic

    func playerTapped(_ choice: Int) {
        let playerMove = moves[choice]
        let computerMove = moves[compChoice]

        var didWin = false

        // Determine if player won
        if (playerMove == "Rock" && computerMove == "Scissors") ||
           (playerMove == "Paper" && computerMove == "Rock") ||
           (playerMove == "Scissors" && computerMove == "Paper") {
            didWin = true
        }

        // Check if correct according to shouldWin
        if didWin == shouldWin {
            resultTitle = "Correct!"
            score += 1
        } else {
            resultTitle = "Wrong!"
            score -= 1
        }

        showingResult = true
    }

    func nextRound() {
        if round < 10 {
            round += 1
            compChoice = Int.random(in: 0...2)
            shouldWin.toggle()
        } else {
            // Reset game
            round = 1
            score = 0
            compChoice = Int.random(in: 0...2)
            shouldWin = Bool.random()
        }
    }

    // MARK: - Helper for icons
    func symbol(for move: String) -> String {
        switch move {
        case "Rock": return "circle.fill"
        case "Paper": return "doc.fill"
        default: return "scissors"
        }
    }
}

#Preview {
    ContentView()
}
