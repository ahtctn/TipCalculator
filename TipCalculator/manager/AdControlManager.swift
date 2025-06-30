//
//  AdControlManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//


import SwiftUI

class AdControlManager {
    static var environment: AdEnvironment = .test // yayınladığında sadece bu satırı değiştir
    
    static var bannerID: String {
        switch environment {
        case .test:
            return "ca-app-pub-3940256099942544/2934735716"
        case .production:
            return "ca-app-pub-9501939639524405/9804703757" // senin banner ID’in
            
        }
    }
    
    static var interstitialID: String {
        switch environment {
        case .test:
            return "ca-app-pub-3940256099942544/4411468910" // Google test interstitial
        case .production:
            return "ca-app-pub-9501939639524405/7508878758" // Senin interstitial ID’in
        }
    }
}
