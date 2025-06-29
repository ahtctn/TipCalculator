//
//  AdvantageRow.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//


import SwiftUI

struct AdvantageRow: View {
    let iconName: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(alignment: .center, spacing: dw(0.04)) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: dw(0.05), height: dw(0.05))
                .foregroundStyle(ColorHandler.makeColor(.lightC))
            
            VStack(alignment: .leading, spacing: dw(0.012)) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.white)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.white.opacity(0.7))
            }
        }
        .padding(.vertical, dw(0.02))
        .padding(.horizontal, dw(0.05))
    }
}
