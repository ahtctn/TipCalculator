//
//  HomeViewModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    // MARK: - App State
    @Published var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @Published var showRegister = !UserDefaults.standard.bool(forKey: "hasSeenRegister")
}
