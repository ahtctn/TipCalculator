//
//  CurrencySelectionView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//


// CurrencySelectionView.swift

import SwiftUI

struct CurrencySelectionView: View {
    @EnvironmentObject var vm: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selected: String

    init(initial: String? = nil) {
        // Seçim, ilk açıldığında mevcut değeri göstersin
        _selected = State(initialValue: initial ?? (Locale.current.currencySymbol ?? "$"))
    }

    // Sık kullanılanlar (gerektikçe artır)
    private let options: [String] = ["$", "€", "£", "₺", "₽", "₹", "¥", "₩", "฿", "₫", "₦", "₪", "₱", "₴", "₡", "₸"]

    var body: some View {
        ZStack {
            AnimatedBackgroundView().ignoresSafeArea()

            VStack(spacing: 18) {
                // Başlıklar
                VStack(spacing: 6) {
                    Text("One last step")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundStyle(.white)
                    Text("Which currency would you like to use?")
                        .font(.system(size: 19, weight: .heavy))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, dw(0.1))
                    
                    Text("💡 Pro tip: You can always switch your currency in Settings later!")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, dw(0.1))

                }
                .padding(.top, dw(0.06))

                // Seçenek ızgarası
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                    ForEach(options, id: \.self) { sym in
                        Button {
                            selected = sym
                        } label: {
                            Text(sym)
                                .font(.system(size: 22, weight: .bold))
                                .frame(maxWidth: .infinity, minHeight: 54)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(sym == selected ? Color.white.opacity(0.18) : Color.white.opacity(0.10))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(sym == selected ? Color.yellow.opacity(0.6) : Color.white.opacity(0.08), lineWidth: 1)
                                )
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(.horizontal, dw(0.06))
                .padding(.top, 6)

                // Custom giriş (opsiyonel — tek karakterlik sembole izin)
                HStack(spacing: 10) {
                    Text("Selected Currency")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.yellow.opacity(0.75))

                    TextField("Symbol", text: Binding(
                        get: { selected },
                        set: { selected = String($0.prefix(2)) } // istersen 1 yap
                    ))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .multilineTextAlignment(.center)
                    .font(.title3.bold())
                    .frame(width: 72, height: 44)
                    .background(Color.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
                }
                .padding(.horizontal, dw(0.06))
                .padding(.top, 4)

                Spacer()

                // Devam
                Button {
                    vm.updateCurrency(selected)
                    vm.completeOnboarding() 
                    dismiss()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.seal.fill")
                        Text("Continue")
                            .font(.headline.weight(.semibold))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.yellow.opacity(0.9), in: Capsule())
                    .foregroundStyle(.black)
                    .shadow(radius: 10, y: 4)
                }
                .padding(.bottom, dw(0.06))
            }
        }
    }
}
