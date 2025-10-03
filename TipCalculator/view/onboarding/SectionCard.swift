//
//  SectionCard.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//



import SwiftUI

struct SectionCard: View {
    let iconName: String
    let title: String
    let subtitle: String
    let strokeColor: Color

    var body: some View {
        HStack(spacing: dw(0.04)) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.45))
                    .frame(width: dw(0.11), height: dw(0.11))
                Image(systemName: iconName)
                    .font(.system(size: dw(0.06), weight: .semibold))
                    .foregroundStyle(strokeColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.65))
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.black.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(strokeColor.opacity(0.45), lineWidth: 1)
                )
                .shadow(color: strokeColor.opacity(0.35), radius: 14, x: 0, y: 8)
        )
    }
}
