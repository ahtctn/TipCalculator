//
//  AnimatedBackgroundView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    @State private var currentIndex = 0
    @State private var isAnimating = false

    private let gradientSteps: [(UnitPoint, UnitPoint)] = [
        (.bottomLeading, .bottomTrailing),
        (.bottomTrailing, .topTrailing),
        (.topTrailing, .topLeading),
        (.topLeading, .bottomLeading)
    ]

    var body: some View {
        let start = gradientSteps[currentIndex].0
        let end = gradientSteps[currentIndex].1

        LinearGradient(
            gradient: Gradient(colors: [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)]),
            startPoint: start,
            endPoint: end
        )
        .ignoresSafeArea()
        .onAppear {
            if !isAnimating {
                isAnimating = true
                startLoopingAnimation()
            }
        }
        .animation(.easeInOut(duration: 10), value: currentIndex)
    }

    private func startLoopingAnimation() {
        Task {
            while true {
                try? await Task.sleep(nanoseconds: 10_000_000_000) // 10 saniye
                await MainActor.run {
                    currentIndex = (currentIndex + 1) % gradientSteps.count
                }
            }
        }
    }
}

#Preview {
    AnimatedBackgroundView()
}
