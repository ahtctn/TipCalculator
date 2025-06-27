//
//  SplashViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    @Published var isAppReady: Bool
    @Published var isAnimationStarting: Bool
    
    init(isAppReady: Bool = false,
         isAnimationStarting: Bool = false) {
        self.isAppReady = isAppReady
        self.isAnimationStarting = isAnimationStarting
        setAppReady()
        startAnimation()
    }
    
    private func setAppReady() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isAppReady = true
        }
    }
    
    func startAnimation() {
        self.isAnimationStarting = true
    }
}

