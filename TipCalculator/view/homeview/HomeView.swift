//
//  HomeView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            TipCalculatorView()
        }
        .environmentObject(vm)
        .fullScreenCover(isPresented: $vm.paywallShown) {
            PaywallView().environmentObject(vm)
        }
    }
}

#Preview {
    HomeView().environmentObject(HomeViewModel())
}

