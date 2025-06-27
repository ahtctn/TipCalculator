//
//  TipCalculatorView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//



import SwiftUI
import SpriteKit

struct TipCalculatorView: View {
    @EnvironmentObject var vm: HomeViewModel

    // Ana fiyat (sadece TextField düzenlerken güncellenir)
    @State private var baseAmount: Double = 0.0
    // TextField ve sonuçları göstermek için kullandığımız metin
    @State private var totalText: String = ""
    // Hangi yüzde seçili?
    @State private var selectedPercent: Int? = nil

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            // Bubble physics sahnesi
            TipBubblePhysicsView { percent in
                if selectedPercent == percent {
                    // Aynı bubble yeniden seçildiyse “deselect”
                    selectedPercent = nil
                    totalText = String(format: "%.2f", baseAmount)
                    print("🫧 %0 seçildi. Yeni total: \(totalText)")
                } else {
                    // Yeni yüzde seçimi
                    selectedPercent = percent
                    let result = baseAmount * (1 + Double(percent) / 100)
                    totalText = String(format: "%.2f", result)
                    print("🫧 %\(percent) seçildi. Yeni total: \(totalText)")
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

                // TOTAL Circle + TextField
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                        .frame(width: dw(0.5597), height: dw(0.5597))
                        .overlay {
                            Circle().fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        ColorHandler.makeColor(.bg1),
                                        ColorHandler.makeColor(.bg2)
                                    ]),
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

                                    HStack(spacing: 0) {
                                        Text("$")
                                            .font(.title2)
                                            .italic()
                                            .foregroundStyle(.white.opacity(0.7))

                                        TextField("Price", text: $totalText)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.center)
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundStyle(.white)
                                            .onTapGesture {
                                                // İlk tıklamada temizle
                                                if totalText.isEmpty || totalText == "0.00" {
                                                    totalText = ""
                                                    baseAmount = 0
                                                    selectedPercent = nil
                                                }
                                            }
                                            .onChange(of: totalText) { newValue in
                                                // Sadece user editing: selectedPercent == nil
                                                guard selectedPercent == nil else { return }
                                                let cleaned = newValue.replacingOccurrences(of: ",", with: ".")
                                                if let value = Double(cleaned) {
                                                    baseAmount = value
                                                } else {
                                                    baseAmount = 0
                                                }
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
        // Boş yere tıklayınca klavyeyi kapat
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    TipCalculatorView().environmentObject(HomeViewModel())
}

