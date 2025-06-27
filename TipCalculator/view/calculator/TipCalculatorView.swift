//
//  TipCalculatorView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI


struct TipBubble: Identifiable {
    let id = UUID()
    let percent: Int
    let xOffset: CGFloat
    let finalY: CGFloat
    let delay: Double
    let radius: CGFloat
}


import SwiftUI
import SpriteKit


struct TipCalculatorView: View {
    @EnvironmentObject var vm: HomeViewModel
    @State private var totalAmount: Double = 45.54
    @State private var totalText: String = "45.54"
    @State private var selectedPercent: Int? = nil

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            TipBubblePhysicsView { percent in
                guard let base = Double(totalText.replacingOccurrences(of: ",", with: ".")) else { return }

                if selectedPercent == percent {
                    // Aynı bubble'a ikinci kez basıldıysa: resetle
                    selectedPercent = nil
                    totalAmount = base
                    totalText = String(format: "%.2f", base)
                    print("🫧 Deselected. Total reset to \(base)")
                } else {
                    selectedPercent = percent
                    let tip = base * Double(percent) / 100
                    let final = base + tip
                    totalAmount = final
                    totalText = String(format: "%.2f", final)
                    print("🫧 %\(percent) seçildi. Yeni total: \(final)")
                }
            }
            .background(Color.clear)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                HeaderView {
                    vm.settingsAppeared = true
                }

                Image(systemName: "die.face.4")
                    .font(.title)
                    .padding()
                    .background(Circle().stroke(Color.white, lineWidth: 3))
                    .foregroundStyle(.white)

                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                        .frame(width: dw(0.5597), height: dw(0.5597))
                        .overlay {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)]),
                                    startPoint: .top,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay {
                                VStack(spacing: 4) {
                                    Text("TOTAL")
                                        .font(.title2)
                                        .italic()
                                        .foregroundStyle(.white.opacity(0.7))

                                    TextField("", text: $totalText)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundStyle(.white)
                                        .onChange(of: totalText) { newValue, _ in
                                            let cleaned = newValue.replacingOccurrences(of: ",", with: ".")
                                            if let value = Double(cleaned) {
                                                totalAmount = value
                                            }
                                        }
                                }
                            }
                        }
                }
                .padding(.top, 10)

                Spacer()
            }
        }
    }
}

#Preview {
    TipCalculatorView().environmentObject(HomeViewModel())
}

