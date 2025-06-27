//
//
//  DefaultButton.swift
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct DefaultButton: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.green)
                Image(systemName: iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.green)
                Spacer()
            }
            .frame(width: dw(0.85), height: dw(0.15))
            .background(Color(.systemGray6))
            .cornerRadius(dw(0.07)) // height'in yarısı gibi olsun diye
            .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: dw(0.07))
                    .stroke(Color.green, lineWidth: 1.5)
            )
        }
    }
}


