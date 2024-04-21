//
//  ContentView.swift
//  Five-Letter-Word-Guesser
//
//  Created by Bassam on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    // State variables
    @State private var currentLetter = ""
    @State private var guessedLetters = [Character]()
    @State private var strikes = 0
    @State private var wins = 0
    @State private var gameOutcome: GameOutcome?
    @State private var currentWord = ""
    @State private var currentCategory = ""
    @State private var validationMessage = ""
    @State private var specialMessage = ""
    @State private var displaySpecialMessage = false
    @State private var displayBalloons = false
    @State private var hasDisplayedSpecialMessage = false
    
    var body: some View {
        VStack {
            Text("Level \(wins + 1)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding()
            
            Text("Hint Category: \(currentCategory)")
                .padding()
            
            HStack {
                Text("Wins: \(wins)")
                    .foregroundColor(Color.green)
                Spacer()
                Text("Strikes: \(strikes)")
                    .foregroundColor(Color.red)
                
            }
            .padding()
            
            Text("Guess the 5-Letter Word!")
                .font(.title)
                .padding()
            
            Text("Word: \(wordToGuess())")
                .foregroundColor(Color.brown)
                .padding()
            
            TextField("Enter a letter", text: Binding(
                get: {
                    self.currentLetter
                },
                set: { newValue in
                    if newValue.count <= 1 {
                        self.currentLetter = newValue
                        self.validationMessage = ""
                    } else {
                        self.validationMessage = "You can only enter one character."
                    }
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .autocapitalization(.none)
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .padding(.bottom, 5)
            }
            
            Button(action: submitGuess) {
                Text("Submit Guess")
            }
            .padding()
            .disabled(gameOutcome == .lose)
            
            if displaySpecialMessage {
                Text(specialMessage)
                    .padding()
            }
            
            if let outcome = gameOutcome, outcome != .winThreeTimesZeroStrikes {
                Text(outcome.message)
                    .font(.headline)
                    .padding()
                
                if outcome == .lose {
                    Button(action: restartGame) {
                        Text("Restart Game")
                    }
                    .padding()
                }
            }
            
            // Display balloons animation if the condition is met
            if displayBalloons {
                BalloonsAnimation()
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
        .padding()
        .onAppear {
            selectRandomWord()
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) { // Set display duration to 8 seconds
                displaySpecialMessage = false // Hide special message after 8 seconds
            }
        }
    }
    
    private func selectRandomWord() {
        let randomEntry = wordCategories.randomElement() ?? ("", "")
        currentWord = randomEntry.key
        currentCategory = randomEntry.value
    }
    
    private func wordToGuess() -> String {
        var displayWord = ""
        let word = currentWord
        for letter in word {
            if guessedLetters.contains(letter) {
                displayWord += String(letter)
            } else {
                displayWord += "_"
            }
        }
        return displayWord
    }
    
    private func submitGuess() {
        guard currentLetter.count == 1 else {
            return
        }
        
        let guessedLetter = Character(currentLetter.lowercased())
        
        if guessedLetters.contains(guessedLetter) {
            return
        }
        
        guessedLetters.append(guessedLetter)
        
        if !currentWord.contains(guessedLetter) {
            strikes += 1
            if strikes >= 3 {
                gameOutcome = .lose
            }
        }
        
        if !wordToGuess().contains("_") {
            gameOutcome = .win
            wins += 1
            selectRandomWord()
            guessedLetters.removeAll()
            
            if !hasDisplayedSpecialMessage && wins % 3 == 0 && strikes == 0 {
                specialMessage = "Congratulations! zero strikes so far!"
                displaySpecialMessage = true // Show special message
                gameOutcome = .winThreeTimesZeroStrikes
                displayBalloons = true // Show balloons animation
                hasDisplayedSpecialMessage = true // Update flag
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) { // Hide balloons after 8 seconds
                    displaySpecialMessage = false
                    displayBalloons = false // Hide balloons animation
                }
            } else {
                specialMessage = ""
            }
        }
        
        currentLetter = ""
    }
    
    // Function to restart the game
    private func restartGame() {
        currentLetter = ""
        guessedLetters = []
        strikes = 0
        gameOutcome = nil
        wins = 0 // Reset wins
        selectRandomWord()
    }
}

enum GameOutcome: Equatable {
    case win
    case lose
    case winThreeTimesZeroStrikes
    
    var message: String {
        switch self {
        case .win:
            return "Congratulations!"
        case .lose:
            return "Game Over! You've reached the maximum number of strikes."
        case .winThreeTimesZeroStrikes:
            return "Congratulations! zero strikes so far!"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
