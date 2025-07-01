//
//  DefaultCellView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI

struct DefaultCellView: View {
    let iconName: String
    let title: String
    let act: () -> Void

    var body: some View {
        Button { act() } label: {
            RoundedRectangle(cornerRadius: dw(0.05))
                .stroke(ColorHandler.makeColor(.bg1), lineWidth: 1.5)
                .background(
                    RoundedRectangle(cornerRadius: dw(0.05))
                        .fill(ColorHandler.makeColor(.bg2))
                        .customShadow()
                )
                .frame(width: dw(0.88), height: dw(0.18))
                
                .overlay(
                    HStack(spacing: dw(0.04)) {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: dw(0.07), height: dw(0.07))
                            .foregroundColor(ColorHandler.makeColor(.lightC))

                        Text(title)
                            .font(.system(size: dw(0.045), weight: .semibold))
                            .foregroundStyle(Color.primary)

                        Spacer()
                    }
                    .padding(.horizontal, dw(0.05))
                )
        }
    }
}
