//
//  XMarkView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//



import SwiftUI

struct XMarkView: View {
    var act: () -> ()
    var body: some View {
        Button {
            act()
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 24, weight: .bold))
                .padding()
                .foregroundColor(ColorHandler.makeColor(.lightC))
        }
        .padding(.leading, dw(0.05))
        .padding(.top, dw(0.05))
    }
}
