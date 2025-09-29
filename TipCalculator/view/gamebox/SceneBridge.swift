//
//  SceneBridge.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.09.2025.
//


import Combine
import SwiftUI

final class SceneBridge: ObservableObject {
    @Published var isBallActive: Bool = false
    @Published var landingText: String? = nil   // örn: "%25"
    @Published var landingPercent: Int? = nil
}
