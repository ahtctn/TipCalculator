//
//  File.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//


import Foundation

// Bundle Extension for App Name and Version
extension Bundle {
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "Unknown App"
    }
    
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var appBuild: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}


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
