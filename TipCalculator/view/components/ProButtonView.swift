//
//  ProButtonView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//


import SwiftUI

struct ProButtonView: View {
    var action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                action()
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: "sparkle")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)

                ZStack {
                    Text("PRO")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                }
                .transition(.opacity)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        Color.yellow,
                        lineWidth: 1.5
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.5))
                    )
            )
            .foregroundColor(.orange)
            .shadow(color: (Color.orange).opacity(0.25), radius: 4, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

