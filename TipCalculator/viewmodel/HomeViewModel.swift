//
//  HomeViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import Foundation
import Combine
import UIKit
import CoreData
internal import SwiftUICore

class HomeViewModel: ObservableObject {
    // MARK: - App State
    @Published var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @Published var showRegister = !UserDefaults.standard.bool(forKey: "hasSeenRegister")
    
    @Published var settingsAppeared: Bool = false
    @Published var baseAmount: Double = 0.0
    
    @Published var totalText: String = ""
    var isProgrammaticUpdate = false
    
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
    
    // MARK: Keys
    private let currencyKey = "settings.currency.symbol"
    
    // MARK: State
    @Published var currency: String  // ⬅️ artık @Published ve UserDefaults’tan yükleniyor
    @Published var showCurrencySheet: Bool = false
    
    ///MARK: CORE DATA
    @Published var showTipSavedSection: Bool = false
    @Published var tipSavedTitleDraft: String = ""   // TipSavedSection'daki TextField için
    @Published var lastSavedTipID: UUID? = nil
    @Published var tipSavedView: Bool = false
    
    ///MARK: Credits
    @Published var credits: Int = 0
    private let maxCredits = 1
    private let creditsCountKey = "credits.count.v1"
    private let creditsLastKey  = "credits.lastDate.v1"
    private let creditsInitializedKey = "credits.initialized.v1" // ilk kredi verildi mi?
    private var lastCreditRefresh: Date = .distantPast
    
    @Published var historyShown = false
    @Published var history: [TipModel] = []
    
    init() {
        let saved = UserDefaults.standard.string(forKey: currencyKey)
        self.currency = saved ?? (Locale.current.currencySymbol ?? "$")
        
        self.showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        loadCreditSystem()
    }
    
    func loadCreditSystem() {
        let d = UserDefaults.standard
        
        // 1) İlk kurulum: daha önce kredi verildiyse tekrar verme
        if !d.bool(forKey: creditsInitializedKey) {
            credits = 1                          // sadece ilk açılışta 1 kredi
            d.set(true, forKey: creditsInitializedKey)
            persistCredits()
        } else {
            credits = max(0, d.integer(forKey: creditsCountKey))
        }
        migrateCreditKeysIfNeeded()
        // 2) GÜNLÜK REFRESH YOK: aşağıdakileri KALDIR
        // refreshCreditsIfNeeded()
        // NotificationCenter.default.addObserver(... refreshCreditsIfNeeded ...)
    }
    
    func migrateCreditKeysIfNeeded() {
        let d = UserDefaults.standard
        // Artık günlük yenileme kullanmıyoruz; tarihi sıfırlayabilirsin
        d.removeObject(forKey: creditsLastKey)
        // creditsCountKey kalsın; mevcut kredi değeri korunur
    }
    
    func trimmedMoney(_ value: Double) -> String {
        guard value.isFinite else { return "—" }
        let intPart = Int(value)
        return (value == Double(intPart)) ? "\(intPart)" : String(format: "%.2f", value)
    }
    
    func openPaywallInSettings() {
        settingsAppeared = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.paywallShown = true
        }
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
        let cleaned = newValue.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(cleaned) else {
            baseAmount = 0
            totalText = ""
            return
        }
        
        baseAmount = value
        
        // Eğer seçili bir yüzde varsa otomatik total hesapla
        if let percent = selectedPercent ?? (customTipPercent > 0 ? customTipPercent : nil) {
            let tip = baseAmount * Double(percent) / 100.0
            let total = baseAmount + tip
            
            isProgrammaticUpdate = true
            totalText = String(format: "%.2f", total)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isProgrammaticUpdate = false
            }
        } else {
            // yüzde yoksa sadece baseAmount göster
            isProgrammaticUpdate = true
            totalText = String(format: "%.2f", baseAmount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isProgrammaticUpdate = false
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
    
    func commitSelectionToHomeIfNeeded(percent: Int? = nil) {
        let p = percent ?? selectedPercent ?? tipPercent
        guard baseAmount > 0, p > 0 else { return }
        
        let tip = baseAmount * Double(p) / 100.0
        let total = baseAmount + tip
        
        isProgrammaticUpdate = true
        totalText = String(format: "%.2f", total)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isProgrammaticUpdate = false
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

extension HomeViewModel {
    // Calculate: hesapla + Core Data'ya kaydet + sheet aç
    func calculateNow() {
        // aktif yüzde
        let percent = selectedPercent ?? (customTipPercent > 0 ? customTipPercent : (isRandomTipActive ? tipPercent : 0))
        guard baseAmount > 0, percent > 0 else { return }
        
        let tip = baseAmount * Double(percent) / 100.0
        lastTipAmount = tip
        let result = baseAmount + tip
        totalText = String(format: "%.2f", result)
        
        // varsayılan başlık taslağı (kullanıcı değiştirir)
        tipSavedTitleDraft = "\(trimmedMoney(result)) \(currency) • \(percent)% tip • \(trimmedMoney(baseAmount)) \(currency) base • \(trimmedMoney(tip)) \(currency) tip"
        
        
        // Core Data kaydı
        let saved = TipCoreDataManager.shared.insertTip(
            title: tipSavedTitleDraft,
            baseAmount: baseAmount,
            percent: percent,
            tipAmount: tip,
            totalAmount: result,
            peopleCount: peopleCount,
            currency: currency
        )
        lastSavedTipID = saved.id
        
        // küçük bir feedback gecikmesi sonra sheet aç
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.showTipSavedSection = true
        }
        loadHistory()
        print("🧮 Manual calc %\(percent) → tip \(String(format: "%.2f", tip)) | total \(totalText) | saved \(saved.id)")
    }
    
    // Kullanıcı title'ı değiştirip kaydettiğinde çağır
    func persistSavedTitle() {
        guard let id = lastSavedTipID else { return }
        TipCoreDataManager.shared.updateTitle(id: id, title: tipSavedTitleDraft)
        loadHistory() // ✔️ title değişince history’yi güncelle
    }
    
    func loadHistory() {
        history = TipCoreDataManager.shared.fetchTips()
    }
}


extension HomeViewModel {
    func deleteHistory(at offsets: IndexSet) {
        for i in offsets {
            TipCoreDataManager.shared.deleteTip(id: history[i].id)
        }
        history.remove(atOffsets: offsets)
    }
    
    func deleteHistory(id: UUID) {
        TipCoreDataManager.shared.deleteTip(id: id)
        loadHistory()
    }
    
    /// Son kaydedilen (TipSavedSection'da görüntülenen) bahşiş kaydını siler.
    func deleteSavedTip() {
        guard let id = lastSavedTipID else { return }
        TipCoreDataManager.shared.deleteTip(id: id)
        lastSavedTipID = nil
        tipSavedTitleDraft = ""
        loadHistory() // ✔️ silince güncelle
    }
}

extension HomeViewModel {
    @discardableResult
    func useOneCredit() -> Bool {
        guard credits > 0 else { return false }
        credits -= 1
        persistCredits()
        return true
    }
    
    // (Opsiyonel) Krediyi manuel setlemek istersen
    func setCredits(_ value: Int) {
        credits = max(0, value)
        persistCredits()
    }
    
    private func persistCredits() {
        let d = UserDefaults.standard
        d.set(credits, forKey: creditsCountKey)
        d.set(lastCreditRefresh, forKey: creditsLastKey)
    }
    
    @discardableResult
    func increaseCredit(by amount: Int = 1) -> Bool {
        guard amount > 0 else { return false }
        let newValue = min(maxCredits, credits + amount)
        guard newValue != credits else { return false } // zaten limitte
        credits = newValue
        persistCredits()
        return true
    }
    
    /// Krediyi azaltır; 0’ın altına düşürmez. Değiştiyse true döner.
    @discardableResult
    func decreaseCredit(by amount: Int = 1) -> Bool {
        guard amount > 0 else { return false }
        guard credits >= amount else { return false }
        credits -= amount
        persistCredits()
        return true
    }
}

//MARK: Currency Management
extension HomeViewModel {
    func updateCurrency(_ symbol: String) {
        guard symbol.isEmpty == false else { return }
        currency = symbol
        UserDefaults.standard.set(symbol, forKey: currencyKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        showOnboarding = false
    }
}
