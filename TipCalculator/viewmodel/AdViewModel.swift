//
//  AdViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI
import Combine
import GoogleMobileAds

class AdViewModel: ObservableObject {
    private let adManager = InterstitialAdManager()
    private var adTimer: Timer?

    init() {
        adManager.loadAd()
        //startAdTimer()
    }

    private func startAdTimer() {
        adTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
            self?.showAdIfReady()
        }
    }

    func showAdIfReady() {
        guard adManager.isAdReady else {
            print("⏳ Reklam hazır değil, daha sonra tekrar denenebilir.")
            return
        }

        if let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController {
            adManager.showAd(from: root)
            print("🎬 Reklam gösterildi.")
        }
    }
}

