//
//  View+Shadow.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import Foundation
import SwiftUI

extension View {
    func customShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.6), radius: 2, x: 0, y: 2)
    }
}
