//
//  AngryHeadShakeView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.09.2025.
//



import SwiftUI

struct AngryHeadShakeView: View {
    var speed: Double = 0.6
    var width: Double = 0.35
    
    var img: ImageHelper.images = .iconnobg

    @State private var shake = false      // Açı arasında gidip gelmek için

    var body: some View {
        ImageHandler.makeImage(img)
            .scaledToFit()
            .frame(width: dw(width))
            .cornerRadius(16)
            .customShadow()
            .rotationEffect(.degrees(shake ? -10 : 10))
            .onAppear {
                start()
            }
    }

    private func start() {
        // Başlatmadan önce bilinen bir duruma al
        shake = false
        // Sonsuz ileri-geri animasyon
        withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
            shake.toggle()
        }
    }
}
