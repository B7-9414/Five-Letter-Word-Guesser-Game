//
//  BalloonsAnimation.swift
//  Five-Letter-Word-Guesser
//
//  Created by Bassam on 3/4/24.
//

import SwiftUI

struct BalloonsAnimation: View {
    @State private var balloons: [Balloon] = []
    
    var body: some View {
        ZStack {
            ForEach(balloons.indices, id: \.self) { index in
                Image(systemName: "circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(balloons[index].color)
                    .frame(width: balloons[index].size, height: balloons[index].size)
                    .offset(balloons[index].position)
                    .onAppear {
                        animateBalloons(index: index)
                    }
            }
        }
        .onAppear {
            generateBalloons()
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                balloons.removeAll()
            }
        }
    }
    
    private func generateBalloons() {
        for _ in 0..<20 {
            let size = CGFloat.random(in: 15...25)
            let position = CGSize(width: CGFloat.random(in: -200...200), height: -UIScreen.main.bounds.height - size) // Start from above the screen
            let duration = Double.random(in: 5...10)
            
            balloons.append(Balloon(size: size, position: position, duration: duration))
        }
    }
    
    private func animateBalloons(index: Int) {
        withAnimation(Animation.linear(duration: balloons[index].duration).repeatForever(autoreverses: false)) {
            balloons[index].position = CGSize(width: balloons[index].position.width, height: UIScreen.main.bounds.height + balloons[index].size)
        }
    }
}

struct Balloon: Identifiable {
    let id = UUID()
    let size: CGFloat
    var position: CGSize
    let duration: Double
    let color: Color = Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
}
