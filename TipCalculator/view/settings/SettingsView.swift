//
//  SettingsView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//



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

// SettingsView.swift

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            VStack {
                HeaderView(
                    name: "Settings",
                    isIconV: false,
                    isDoneV: true,
                    isHistoryVisible: false,
                    act: {},
                    pro_act: {
                        homeVM.openPaywallInSettings()
                    },
                    done_act: {
                        homeVM.settingsAppeared = false
                    }
                )

                VStack(spacing: 20) {
                    
                    VStack(spacing: 12) {
                        // Currency seçimi
                        DefaultCellView(iconName: "coloncurrencysign.circle.fill",
                                        title: "Currency (\(homeVM.currency))") {
                            homeVM.showCurrencySheet = true
                        }

                        DefaultCellView(iconName: "star.fill", title: "Rate Us!") {
                            RateHelper.rateUs() { _ in print("Rate Us!") }
                        }

                        DefaultCellView(iconName: "mail.fill", title: "Offer a Feature") {
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
                    
                    BannerPaywallView {
                        homeVM.openPaywallInSettings()
                    }
                }

                Spacer()
                companyLogo
                Spacer().frame(height: dw(0.05))
            }
        }
        .sheet(isPresented: $homeVM.showCurrencySheet) {
            CurrencySelectionView(initial: homeVM.currency)
                .environmentObject(homeVM)
        }
    }
}

extension SettingsView {
    private var companyLogo: some View {
        ImageHandler.makeImage(.company_logo)
            .frame(width: dw(0.1526), height: dw(0.1526))
            .scaledToFit()
            .background(.clear)
    }
}


