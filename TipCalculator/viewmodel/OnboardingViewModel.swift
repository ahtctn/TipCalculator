//
//  OnboardingViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//


import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    let model: [OnboardingModel] = [
        OnboardingModel(title: "Pick a Balloon, Pop Your Tip!", subtitle: "Tipping is now a game. Pick a balloon or get a random percent—let fate decide!", animName: "ob1"),
        OnboardingModel(title: "Realistic Physics, Real Fun", subtitle: "Balloons bounce, roll, and reveal surprise tip percentages—ready to play?", animName: "ob2"),
        OnboardingModel(title: "Random or Custom—You Choose", subtitle: "Roll the dice for a surprise or enter your own tip. You’re in full control!", animName: "ob3")
    ]
    
    init() {}
}
