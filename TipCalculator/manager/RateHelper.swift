//
//  RateHelper.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI
import StoreKit

class RateHelper {
    static func rateUs(result: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {result(false); return }
            SKStoreReviewController.requestReview(in: windowScene)
            result(true)
        }
    }
}
