//
//  LoadingSplashView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SwiftUI

struct LoadingSplashView: View {
    
    @Binding var isAppReady: Bool
    @State private var progress: CGFloat
    
    init(_ isAppReady: Binding<Bool> = .constant(false),
         progress: CGFloat = 0) {
        _isAppReady = isAppReady
        self.progress = progress
    }
    
    var body: some View {
        
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                Color.white,
                style: StrokeStyle(
                    lineWidth: 1,
                    lineCap: .round,
                    dash: [2, 5]
                )
            )
            .frame(width: dw(0.6))
            .rotationEffect(.degrees(-90))
            .scaleEffect(x: -1, y: 1)
            .onAppear {
                withAnimation(.linear(duration: 10)) {
                    progress = 0.9
                }
            }
            .onChange(of: isAppReady) { newValue, _ in
                if newValue {
                    progress = 1
                }
            }

    }
}
