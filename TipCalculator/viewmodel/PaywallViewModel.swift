//
//  PaywallViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//

import SwiftUI
import RevenueCat
import Combine

class PaywallViewModel: ObservableObject {
    @Published var xmarkVisible: Bool = false
    
    var purchaseManager = PurchaseManager.shared
    private var fetchTimer: Timer?
    
    @Published var isPremium: Bool = false
    
    @Published var selectedProductID: String = "rc_1299_lifetime"

    @Published var isPurchasing: Bool = false
    @Published var availableProducts: [StoreProduct] = []
    
    @Published var purchaseCompleted: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    init() {
        self.availableProducts = purchaseManager.availableProducts
        self.startFetchingPackages()
        purchaseManager.$isPurchasing
            .receive(on: DispatchQueue.main)
            .assign(to: \.isPurchasing, on: self)
            .store(in: &cancellables)
        purchaseManager.$isPremium
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPremium in
                self?.isPremium = isPremium
                if isPremium {
                    self?.purchaseCompleted = true // ⭐️ Satın alma başarıyla bitince trigger
                }
            }
            .store(in: &cancellables)
        
        purchaseManager.$availableProducts
                .receive(on: DispatchQueue.main)
                .assign(to: \.availableProducts, on: self)
                .store(in: &cancellables)
        
    }
    
    func pwAppeared() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.xmarkVisible = true
        }
        updatePremiumStatus()
    }
    
    func fetchOfferings() {
        purchaseManager.fetchOfferings()
        self.availableProducts = purchaseManager.availableProducts
    }
    
    func startFetchingPackages() {
        self.fetchOfferings()
        
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.fetchOfferings()

            if let firstProduct = self.availableProducts.first {
                self.selectedProductID = firstProduct.productIdentifier
                print("🎯 Default seçilen ürün ID: \(firstProduct.productIdentifier)")
            }

            if !self.availableProducts.isEmpty {
                print("✅ Paketler bulundu, Timer durduruldu.")
                timer.invalidate()
            }
        }
    }

    
    func purchaseProduct(productID: String, completion: ((Bool) -> Void)? = nil) {
        purchaseManager.purchaseProduct(productID: productID) { success in
            DispatchQueue.main.async {
                self.purchaseCompleted = success
                completion?(success)
            }
        }
    }

    
    func restorePurchases() {
        purchaseManager.restorePurchases()
    }
    
    func updatePremiumStatus() {
        isPremium = purchaseManager.isPremium
    }
}
