//
//  TipCalculatorApp.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

@main
struct TipCalculatorApp: App {
    @StateObject private var homeVM: HomeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            HomeDelegate()
        }.environmentObject(homeVM)
    }
}
