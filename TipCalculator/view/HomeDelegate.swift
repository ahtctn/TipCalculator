//
//  HomeDelegate.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct HomeDelegate: View {
    @EnvironmentObject var vm: HomeViewModel
    @StateObject private var splashVM = SplashViewModel()
    var body: some View {
        Group {
            switch splashVM.isAppReady {
            case true:
                if vm.showOnboarding {
                    OnboardingView()
                        .environmentObject(vm)
                    
                } else {
                    HomeView()
                        .environmentObject(vm)
                }
            case false:
                SplashView()
                    .environmentObject(splashVM)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeDelegate()
}
