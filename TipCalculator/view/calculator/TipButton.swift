//
//  TipButton.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//



import SwiftUI

struct TipButton: View {
    var percent: Int
    
    var body: some View {
        Text("%\(percent)")
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 80, height: 80)
            .background(
                Circle()
                    .stroke(Color.white, lineWidth: 4)
            )
    }
}

#Preview {
    TipCalculatorView().environmentObject(HomeViewModel())
}
