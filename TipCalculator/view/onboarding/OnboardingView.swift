//
//  OnboardingView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        Text("Onboarding View").font(.largeTitle)
        
        DefaultButton(title: "Tap", iconName: "person.fill") {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                   homeVM.showOnboarding = false
        }
    }
}

#Preview {
    OnboardingView()
}
