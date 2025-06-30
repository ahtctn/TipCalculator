//
//  AdMobBannerView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI
import GoogleMobileAds

struct AdMobBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)

        bannerView.adUnitID = AdControlManager.bannerID

        bannerView.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.rootViewController

        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // burada güncellemeye gerek yok
    }
}


