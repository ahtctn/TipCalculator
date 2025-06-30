//
//  InterstitialAdManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import GoogleMobileAds
import UIKit

class InterstitialAdManager {
    private var interstitial: InterstitialAd?

    func loadAd() {
        let request = Request()
        InterstitialAd.load(with: AdControlManager.interstitialID, request: request) { ad, error in
            if let error = error {
                print("❌ Reklam yüklenemedi: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            print("✅ Reklam yüklendi!")
        }
    }

    var isAdReady: Bool {
        interstitial != nil
    }

    func showAd(from rootViewController: UIViewController) {
        guard let interstitial = interstitial else {
            print("📭 Reklam hazır değil.")
            return
        }
        interstitial.present(from: rootViewController)
        self.interstitial = nil // gösterildikten sonra sıfırla
        loadAd() // yenisini yükle
    }
}
