//
//  HomeViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import Foundation
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    // MARK: - App State
    @Published var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @Published var showRegister = !UserDefaults.standard.bool(forKey: "hasSeenRegister")
    
    @Published var settingsAppeared: Bool = false
    @Published var baseAmount: Double = 0.0
    @Published var totalText: String = ""
    
    @Published var selectedPercent: Int? = nil
    @Published var tipPercent: Int = 0
    @Published var rollCount = 0
    @Published var isRolling = false
    @Published var isRandomTipActive: Bool = false
    @Published var customTipText: String = ""
    @Published var customTipPercent: Int = 0
    
    @Published var paywallShown: Bool = false
    
    @Published var bannerShown: Bool = false
    @Published var presentGameBox: Bool = false
    
    @Published var lastTipAmount: Double = 0.0
    
    @Published var peopleCount: Int = 1
    @Published var expandSplit: Bool = false
    @Published var showCustomPeople: Bool = false
    @Published var customPeopleText: String = "4"
    
    let currency = Locale.current.currencySymbol ?? "$"
    
    func trimmedMoney(_ value: Double) -> String {
        guard value.isFinite else { return "—" }
        let intPart = Int(value)
        return (value == Double(intPart)) ? "\(intPart)" : String(format: "%.2f", value)
    }
    
    func rollDice() {
        customTipPercent = 0
        customTipText = ""
        toggleRandomTip()
    }
    func showGameBox() {
        presentGameBox = true
        isRandomTipActive = false
        resetRandomTip()
    }
    
    func applyGamePercent(_ percent: Int) {
        // random/custom modları kapat
        isRandomTipActive = false
        customTipPercent = 0
        customTipText = ""
        
        selectedPercent = percent
        // hesap
        let tip = baseAmount * Double(percent) / 100.0
        lastTipAmount = tip
        let result = baseAmount + tip
        totalText = String(format: "%.2f", result)
        
        tipPercent = percent
        print("🎰 GameBox %\(percent) → tip $\(String(format: "%.2f", tip)) | total \(totalText)")
    }
    
    
    func toggleRandomTip() {
        isRolling = true
        rollCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [self] timer in
            tipPercent = Int.random(in: 10...30)
            rollCount += 1
            
            if rollCount == 10 {
                timer.invalidate()
                isRolling = false
                
                // ✅ Yeni random tip seçimi
                selectedPercent = tipPercent
                isRandomTipActive = true
                let result = baseAmount * (1 + Double(tipPercent) / 100)
                totalText = String(format: "%.2f", result)
                print("🎲 %\(tipPercent) seçildi. Yeni total: \(totalText)")
            }
        }
    }
    
    func textfieldTapGesture() {
        resetRandomTip()
        if totalText.isEmpty || totalText == "0.00" {
            totalText = ""
            baseAmount = 0
            selectedPercent = nil
        }
    }
    
    func textFieldOnChange(_ newValue: String) {
        if !isRandomTipActive && selectedPercent == nil {
            let cleaned = newValue.replacingOccurrences(of: ",", with: ".")
            if let value = Double(cleaned) {
                baseAmount = value * 10
            } else {
                baseAmount = 0
            }
        }
    }
    
    func resetRandomTip() {
        isRandomTipActive = false
        isRolling = false
        rollCount = 0
        tipPercent = 0
        selectedPercent = nil
        totalText = String(format: "%.2f", baseAmount)
        print("🔄 Random tip resetlendi. Total sıfırlandı: \(totalText)")
    }
    
    func updateCustomTipOnKeyboardHide() {
        guard let value = Int(customTipText), value >= 0 && value <= 100 else { return }
        
        selectedPercent = value
        customTipPercent = value
        
        if value == 0 {
            totalText = String(format: "%.2f", baseAmount)
            print("🫧 (klavye kapandı) %0 girildi. Total sıfırlandı: \(totalText)")
        } else {
            let result = baseAmount * (1 + Double(value) / 100)
            totalText = String(format: "%.2f", result)
            print("🫧 (klavye kapandı) %\(value) girildi. Yeni total: \(totalText)")
        }
    }
    
    func bubblePercentAction(_ percent: Int) {
        resetRandomTip()
        if selectedPercent == percent {
            // Aynı bubble yeniden seçildiyse “deselect”
            selectedPercent = nil
            totalText = String(format: "%.2f", baseAmount)
            print("🫧 %0 seçildi. Yeni total: \(totalText)")
        } else {
            // Yeni yüzde seçimi
            selectedPercent = percent
            let result = baseAmount * (1 + Double(percent) / 100)
            totalText = String(format: "%.2f", result)
            print("🫧 %\(percent) seçildi. Yeni total: \(totalText)")
        }
    }
    
    
    func controlKeyboard() {
        UIApplication.shared.endEditing()
    }
}
