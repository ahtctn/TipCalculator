//
//  OnboardingView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            GeometryReader { geo in
                VStack {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(viewModel.model.enumerated()), id: \.offset) { index, model in
                            VStack(spacing: 24) {
                                LottieAnimationManager(name: model.animName, loopMode: .loop)
                                    .frame(width: dw(0.8), height: dw(0.8))
                                
                                Text(model.title)
                                    .font(.title)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(ColorHandler.makeColor(.lightC))
                                
                                Text(model.subtitle)
                                    .font(.system(size: 21))
                                    .foregroundColor(ColorHandler.makeColor(.lightC).opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .frame(width: geo.size.width)
                            .tag(index) // Net ve stabil index tag’i
                        }
                    }

                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .animation(.easeInOut, value: currentIndex)
                    
                    
                    DefaultButton(title: currentIndex < viewModel.model.count - 1 ? "Continue" : "Let's Tip!", iconName: "arrow.right") {
                        if currentIndex < viewModel.model.count - 1 {
                            currentIndex += 1
                        } else {
                            // Navigate to next view
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                            homeVM.showOnboarding = false
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}

