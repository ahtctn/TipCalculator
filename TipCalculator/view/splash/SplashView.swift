//
//  SplashView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var viewModel: SplashViewModel
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            VStack {
                Spacer()
                Spacer()
                LoadingSplashView($viewModel.isAppReady)
                    .overlay {
                        ImageHandler.makeImage(.applogo)
                            .scaledToFit()
                            .frame(width:  dw(0.3))
                            .cornerRadius(16)
                            .customShadow()
                    }
                    .opacity(viewModel.isAnimationStarting ? 1 : 0)
                    .scaleEffect(viewModel.isAnimationStarting ? 1 : 0.8)
                    .animation(.easeOut(duration: 0.8), value: viewModel.isAnimationStarting)
                Spacer()
                VStack(spacing: 20) {
                    let splash = "Tip Calculator"
                    let parts = splash.components(separatedBy: "\n")
                    let title = parts.first ?? ""
                    let subtitle = parts.count > 1 ? parts[1] : ""

                    VStack {
                        Text(title)
                            .bold()
                            .foregroundStyle(Color.white)
                            .font(.system(size: 18))
                        
                        Text(subtitle)
                            .bold()
                            .italic()
                            .foregroundStyle(Color.white)
                            .font(.system(size: 12)).italic()
                            .multilineTextAlignment(.center)
                    }


                    
                    ImageHandler.makeImage(.company_logo)
                        .frame(width: 60, height: 60)
                        .scaledToFit()
                        .opacity(viewModel.isAnimationStarting ? 1 : 0)
                        .scaleEffect(viewModel.isAnimationStarting ? 1 : 0.8)
                        .animation(.easeOut(duration: 0.8), value: viewModel.isAnimationStarting)
                        .background(.clear)
                }
            }
            .onAppear {
                viewModel.startAnimation()
            }
        }
    }
}

#Preview {
    SplashView(viewModel: .init())
        .environmentObject(SplashViewModel())
}
