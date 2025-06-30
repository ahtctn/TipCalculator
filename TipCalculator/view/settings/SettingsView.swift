//
//  SettingsView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack {
            HeaderView(name: "Settings", isIconV: false, isDoneV: true, act: {}, pro_act: {
                homeVM.settingsAppeared = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    homeVM.paywallShown = true
                }
            }, done_act: {
                homeVM.settingsAppeared = false
            })
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
