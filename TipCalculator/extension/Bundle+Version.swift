//
//  Bundle+Version.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//

import Foundation

extension Bundle {
    /// Uygulamanın versiyonu belirtilen versiyonla karşılaştırılır.
    /// - Returns: true = mevcut versiyon <= verilen versiyon
    func isVersionLessThanOrEqual(to version: String) -> Bool {
        guard let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        return currentVersion.compare(version, options: .numeric) != .orderedDescending
    }
}
