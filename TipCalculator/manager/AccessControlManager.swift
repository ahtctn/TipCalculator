//
//  AccessControlManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//

import Foundation

struct AccessControlManager {
    
    private static let promotionUserKey = "isPromotionUser"
    
    /// Kullanıcının promotion kullanıcı olup olmadığını belirler
    static var isPromotionUser: Bool {
        get {
            UserDefaults.standard.bool(forKey: promotionUserKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: promotionUserKey)
        }
    }
    
    /// İlk app açılışında kullanıcı için promotion kontrolü yapar
    static func initializePromotionStatusIfNeeded(minimumVersion: String = "0.9") {
        if UserDefaults.standard.object(forKey: promotionUserKey) == nil {
            if Bundle.main.isVersionLessThanOrEqual(to: minimumVersion) {
                isPromotionUser = true
                print("[AccessControlManager] Promotion User: ✅ (App Version <= \(minimumVersion))")
            } else {
                isPromotionUser = false
                print("[AccessControlManager] Promotion User: ❌ (App Version > \(minimumVersion))")
            }
        } else {
            print("[AccessControlManager] Promotion User already set: \(isPromotionUser ? "✅ true" : "❌ false")")
        }
    }
    
    /// Kullanıcının Paywall görüp görmeyeceğini döner
    static func shouldShowPaywall() -> Bool {
        let isPremium = PurchaseManager.shared.isPremium
        
        if isPromotionUser {
            print("[AccessControlManager] No Paywall: Promotion user.")
            return false
        } else if isPremium {
            print("[AccessControlManager] No Paywall: Already premium.")
            return false
        } else {
            print("[AccessControlManager] Show Paywall: Not promotion, not premium.")
            return true
        }
    }
}
