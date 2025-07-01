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
            bannerView
        }
        
        .environmentObject(vm)
        .fullScreenCover(isPresented: $vm.paywallShown) {
            PaywallView().environmentObject(vm)
        }
        .fullScreenCover(isPresented: $vm.settingsAppeared) {
            SettingsView().environmentObject(vm)
        }
    }
}

#Preview {
    HomeView().environmentObject(HomeViewModel())
}

extension HomeView {
    private var bannerView: some View {
        Group {
            if vm.bannerShown {
                DefaultBannerView(anim: "warning", txt: "You need to add total firstly") {
                    vm.bannerShown = false
                }
            } else {
                EmptyView()
            }
        }
    }
}
