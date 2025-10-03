//
//  TipSavedMessageView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//

import SwiftUI
import Lottie

struct TipSavedMessageView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.45)
                .ignoresSafeArea(.all)
                .onTapGesture {
                homeVM.tipSavedView = false
            }
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(colors: [
                        ColorHandler.makeColor(.bg1),
                        ColorHandler.makeColor(.bg2)
                    ], startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                .frame(width: dw(0.8), height: dw(0.8),)
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.yellow, lineWidth: 1.5)
                        .overlay {
                            VStack {
                                LottieAnimationManager(name: "checkmark", loopMode: .loop)
                                    .frame(width: dw(0.4), height: dw(0.4))
                                Spacer()
                                VStack(alignment: .center, spacing: 4) {
                                    Text("Tip Saved Successfully")
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.white)
                                    Text("You can check in the history section below.")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.65))
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.9)
                                    Spacer()
                                    Button {
                                        homeVM.tipSavedView = false
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "checkmark.seal.fill")
                                            Text("Got It!")
                                                .font(.headline.weight(.semibold))
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .background(Color.yellow.opacity(0.9), in: Capsule())
                                        .foregroundStyle(.black)
                                        .shadow(radius: 10, y: 4)
                                    }
                                    Spacer()
                                    Spacer()
                                }
                            }
                        }
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                homeVM.tipSavedView = false
            }
        }
    }
}

#Preview {
    TipSavedMessageView()
}
