//
//  View+Dyn.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import Foundation
import SwiftUI

extension View {
    
    func dw(_ double: Double) -> Double {
        boundsUI.width * double
    }
    
    func dh(_ double: Double) -> Double {
         boundsUI.height * double
    }
}

extension View {
    func rotate(_ degrees: Double) -> some View {
        return self.rotationEffect(Angle(degrees: degrees))
    }
}
