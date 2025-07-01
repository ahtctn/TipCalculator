//
//  SettingsView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            VStack {
                HeaderView(name: "Settings", isIconV: false, isDoneV: true, act: {}, pro_act: {
                    homeVM.settingsAppeared = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        homeVM.paywallShown = true
                    }
                }, done_act: {
                    homeVM.settingsAppeared = false
                })
                
                
                VStack(spacing: 20) {
                    BannerPaywallView {
                        homeVM.settingsAppeared = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            homeVM.paywallShown = true
                        }
                    }
                    
                    VStack(spacing: 12) {
                        DefaultCellView(iconName: "star.fill", title: "Rate Us!") {
                            
                            RateHelper.rateUs() { _ in
                                print("Rate Us!")
                            }
                        }
                        
                        DefaultCellView(iconName: "mail.fill", title: "Offer a Feature") {
                            print("Offer a Feature")
                            vm.sendMail(subject: "My Offer", header: "Hello, I want to offer a feature about")
                        }
                        
                        DefaultCellView(iconName: "paperplane", title: "Send a Friend") {
                            homeVM.settingsAppeared = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                vm.shareApp()
                            }
                        }
                        
                        DefaultCellView(iconName: "envelope.fill", title: "Get Support") {
                            vm.sendMail(subject: "I need Support", header: "Hello, I need support about a topic.")
                        }
                    }
                }
                
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView()
}

import Combine
import SwiftUI

class SettingsViewModel: ObservableObject {
    func shareApp() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            ShareManager.shared.shareApp(from: rootVC)
        }
    }
    
    func sendMail(subject: String, header: String) {
        MailManager.shared.sendSupportEmail(
            subject: subject,
            messageHeader: header,
            toAdress: "newroadsoftware@gmail.com"
        )
    }
}
