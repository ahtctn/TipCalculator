//
//  TipCalculatorApp.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI
import RevenueCat

@main
struct TipCalculatorApp: App {
    @StateObject private var homeVM: HomeViewModel = HomeViewModel()
    init() {initializer()}
    var body: some Scene {
        
        WindowGroup {
            HomeDelegate()
        }
        .environmentObject(homeVM)
    }
    
    private func initializer() {
        getPurchase()
        AccessControlManager.initializePromotionStatusIfNeeded()
    }
    
    private func getPurchase() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: PW.api_key)
        PurchaseManager.shared.updateCustomerInfo()
    }
}
