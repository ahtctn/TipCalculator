//
//  PurchaseManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//

import Foundation
import RevenueCat
import Combine

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var isPremium: Bool = false
    @Published var availableProducts: [StoreProduct] = []
    @Published var isPurchasing: Bool = false
    @Published var statusUpdated: Bool = false
    
    var isOriginalUser: Bool {
        return UserDefaults.standard.bool(forKey: "isOriginalUser")
    }
    
    private let offeringsID = "default"
    private let entitlementID = "Premium"
    
    private init() {
        fetchOfferings()
        updateCustomerInfo()
    }
    
    func fetchOfferings() {
        
        Purchases.shared.getOfferings { [weak self] offerings, error in
            if let error = error {
                print("❌ Error fetching offerings: \(error.localizedDescription)")
                return
            }

            guard let offerings = offerings else {
                print("⚠️ Offerings geldi ama boş.")
                return
            }

            // 📦 Mevcut tüm offering'leri yazdır
            print("📦 Available offerings:")
            for (key, offering) in offerings.all {
                print("➡️ Offering Key: \(key)")
                for pkg in offering.availablePackages {
                    print("   • Package: \(pkg.identifier)")
                    print("   • Product ID: \(pkg.storeProduct.productIdentifier)")
                    print("   • Price: \(pkg.storeProduct.price)")
                    print("   • Localized Title: \(pkg.storeProduct.localizedTitle)")
                }
            }

            // ✅ Default offering ID üzerinden alınanlar
            let selectedOffering = offerings.offering(identifier: self?.offeringsID ?? "")
            if let selectedOffering = selectedOffering {
                let products = selectedOffering.availablePackages.map { $0.storeProduct }
                self?.availableProducts = products
                print("✅ Default offering '\(self?.offeringsID ?? "")' içindeki ürünler yüklendi.")
            } else {
                print("⚠️ Offering ID '\(self?.offeringsID ?? "")' bulunamadı.")
            }
        }
    }

    func purchaseProduct(productID: String, completion: ((Bool) -> Void)? = nil) {
        guard let product = availableProducts.first(where: { $0.productIdentifier == productID }) else {
            print("Product not found: \(productID)")
            completion?(false)
            return
        }

        isPurchasing = true

        Purchases.shared.purchase(product: product) { [weak self] _, customerInfo, error, _ in
            self?.isPurchasing = false

            if let error = error {
                print("❌ Error purchasing product: \(error.localizedDescription)")
                // 🔄 Her durumda güncelle
                self?.updateCustomerInfo()
                completion?(false)
                return
            }

            if let customerInfo = customerInfo {
                self?.updatePremiumStatus(customerInfo: customerInfo)
            }
            
            self?.updateCustomerInfo()
            completion?(true)
        }
    }

    
    func restorePurchases() {
        isPurchasing = true
        Purchases.shared.restorePurchases { [weak self] customerInfo, error in
            self?.isPurchasing = false
            if let error = error {
                print("Error restoring purchases: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                self?.updatePremiumStatus(customerInfo: customerInfo)
            }
            // 🔄 Yine de garantiye alalım
            self?.updateCustomerInfo()
        }
    }
    
    func updateCustomerInfo() {
        Purchases.shared.getCustomerInfo { [weak self] customerInfo, _ in
            if let customerInfo = customerInfo {
                self?.updatePremiumStatus(customerInfo: customerInfo)
            }
        }
    }
    
    private func updatePremiumStatus(customerInfo: CustomerInfo) {
        DispatchQueue.main.async { [weak self] in
            let isPremium = customerInfo.entitlements[self?.entitlementID ?? ""]?.isActive == true
            self?.isPremium = isPremium
            print("User Status: \(isPremium ? "Premium" : "Free")")
        }
        self.statusUpdated = true
    }
    
}
