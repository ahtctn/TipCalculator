//
//  TipCalculatorView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI
import SpriteKit
import Lottie

struct TipCalculatorView: View {
    @EnvironmentObject var vm: HomeViewModel
    @StateObject private var adVM = AdViewModel()
     
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            // Bubble physics sahnesi
            TipBubblePhysicsView(
                onTap: { percent in
                    if vm.totalText == "" {
                        vm.bannerShown = true // 💯 Artık çalışacak
                    } else {
                        vm.bubblePercentAction(percent)
                    }
                },
                isInteractionEnabled: vm.totalText != ""
            )


            .background(Color.clear)
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HeaderView { vm.settingsAppeared = true } pro_act: { vm.paywallShown = true } done_act: { }
                //bannerView
                upperSectionView
                totalCircleView
                splitSummaryView
                customTipTextField
                gameboxView
                Spacer()
            }
            
            if vm.expandSplit {
                splitPeopleOverlay
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(999)
            }
            
            if vm.showTipSavedSection {
                TipSavedSection()
                    .environmentObject(vm)
            }

        }
        // Boş yere tıklayınca klavyeyi kapat
        .onTapGesture {
            vm.controlKeyboard()
        }
        .onAppear {
            //adVM.showAdIfReady()
        } 
        .fullScreenCover(isPresented: $vm.presentGameBox) {
            GameBoxView()
                .environmentObject(vm)
        }

    }
}
//MARK: Dice
extension TipCalculatorView {
    
    // RANDOM TIP — splitBillSection ile uyumlu tasarım
    private var randomTipSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ROLL DICE")
                .font(.footnote)
                .foregroundStyle(ColorHandler.makeColor(.lightC))

            Button {
                if vm.totalText.isEmpty {
                    vm.bannerShown = true
                } else {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                        vm.rollDice()
                    }
                }
            } label: {
                HStack(spacing: 14) {
                    Image(systemName: vm.isRolling ? "arrow.2.circlepath" : "die.face.4")
                        .imageScale(.medium)
                        .rotationEffect(vm.isRolling ? .degrees(360) : .degrees(0))
                        .animation(
                            vm.isRolling
                                ? .linear(duration: 0.8).repeatForever(autoreverses: false)
                                : .default,
                            value: vm.isRolling
                        )

                    Text("\(vm.tipPercent)%")
                        .font(.headline.weight(.semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(vm.rollCount >= 10 ? .green : Color.white)
                .shadow(radius: 8, y: 4)
                .contentShape(Rectangle())
            }
            .disabled(vm.isRolling)
        }
    }
   
    private var gameboxView: some View {
        Button {
            if vm.totalText == "" {
                vm.bannerShown = true // 💯 Artık çalışacak
            } else {
                vm.showGameBox()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "gamecontroller.fill").imageScale(.large)
                Text("Game Box").bold()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.yellow.opacity(0.2), in: Capsule())
            .foregroundStyle(Color.yellow)
        }
    }
}

//MARK: Custom Percent Text Field
extension TipCalculatorView {
    private var customTipTextField: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(Color.white.opacity(0.1))
            .frame(width: dw(0.3), height: 60)
            .overlay(
                HStack(spacing: 4) {
                    tipTextField
                    percentView
                }
                    .padding(.horizontal, 8)
            ).onTapGesture {
                if vm.totalText == "" {
                    vm.bannerShown = true
                }
            }
        
        
            .frame(height: dw(0.1526))
    }
    
    private var tipTextField: some View {
        TextField("Tip %", text: $vm.customTipText)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.center)
            .font(.title3.bold())
            .foregroundStyle(ColorHandler.makeColor(.lightC))
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                vm.updateCustomTipOnKeyboardHide()
            }
            .disabled(vm.totalText == "")
    }
    
    private var percentView: some View {
        Group {
            if !vm.customTipText.isEmpty {
                Text("%")
                    .font(.title3.bold())
                    .foregroundStyle(ColorHandler.makeColor(.lightC))
            }
        }
    }
}

//MARK: Upper Section View {
extension TipCalculatorView {
    private var upperSectionView: some View {
        HStack {
            randomTipSection
            Spacer()
            calculateButton
            Spacer()
            splitBillSection
            
        }
        .padding(.horizontal)
    }
    
    private var calculateButton: some View {
        Button {
            if vm.totalText.isEmpty {
                vm.bannerShown = true
            } else {
                vm.showTipSavedSection = true
            }
            
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .imageScale(.medium)
                Text("Tip")
                    .font(.headline.weight(.semibold))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.12), in: Capsule())
            .foregroundStyle(.white)
            .shadow(radius: 8, y: 4)
        }
    }

}

//MARK: Total Circle View
extension TipCalculatorView {
    private var totalCircleView: some View {
        Circle()
            .stroke(Color.white, lineWidth: 6)
            .frame(width: dw(0.5597), height: dw(0.5597))
            .overlay {
                outerCircleView
            }
            .padding(.top, 10)
    }
    
    private var textFieldHeader: some View {
        HStack {
            Text(vm.currency)
                .font(.title2)
                .italic()
                .foregroundStyle(.white.opacity(0.7))
            
            
            Text("TOTAL")
                .font(.title2)
                .italic()
                .foregroundStyle(.white.opacity(0.7))
            
        }
    }
    
    private var priceTextField: some View {
        TextField("Price", text: Binding(
            get: {
                // Görünüm için formatlanmış değer
                if let value = Double(vm.totalText) {
                    let intPart = Int(value)
                    if value == Double(intPart) { // .00 ise
                        return String(intPart)
                    } else {
                        return String(format: "%.2f", value)
                    }
                }
                return vm.totalText
            },
            set: { vm.totalText = $0 }
        ))
        .keyboardType(.decimalPad)
        .multilineTextAlignment(.center)
        .font(.system(size: 40, weight: .bold))
        .foregroundStyle(.white)
        .onTapGesture {
            vm.textfieldTapGesture()
        }
        .onChange(of: vm.totalText) { newValue, _ in
            vm.textFieldOnChange(newValue)
        }
    }

    
    private var textFieldComponents: some View {
        VStack(spacing: 4) {
            textFieldHeader
            priceTextField
        }
    }
    
    private var outerCircleView: some View {
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
            textFieldComponents
        }
    }
}

#Preview {
    TipCalculatorView().environmentObject(HomeViewModel())
}

extension TipCalculatorView {
    private var bannerView: some View {
        Group {
            if AccessControlManager.shouldShowPaywall() {
                HStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(height: 50)
                    Spacer()
                }
            } else {
                EmptyView()
            }
        }
    }
    
    private var splitBillSection: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text("SPLIT BILL")
                .font(.footnote)
                .foregroundStyle(ColorHandler.makeColor(.lightC))

            Button {
                if vm.totalText.isEmpty {
                    vm.bannerShown = true
                } else {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                        vm.expandSplit.toggle()
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: vm.peopleCount == 1 ? "person"
                          : vm.peopleCount == 2 ? "person.2"
                          : vm.peopleCount == 3 ? "person.3"
                                       : "person.3.sequence")
                        .imageScale(.medium)
                    Text("\(vm.peopleCount) \(vm.peopleCount == 1 ? "Person" : "People")")
                        .font(.headline.weight(.semibold))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(.white)
                .shadow(radius: 8, y: 4)
                .contentShape(Rectangle())
            }
        }
    }

    @ViewBuilder
    private var splitPeopleOverlay: some View {
        ZStack {
            // Dim arka plan
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.18)) { vm.expandSplit = false }
                }

            // Kart
            VStack(spacing: 14) {
                // Drag handle
                Capsule()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 42, height: 5)
                    .padding(.top, 10)

                Text("Select People")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.95))

                // Hızlı seçimler
                HStack(spacing: 10) {
                    ForEach([1,2,3], id: \.self) { k in
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                vm.peopleCount = k
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    vm.expandSplit = false
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: k == 1 ? "person" : k == 2 ? "person.2" : "person.3")
                                    .imageScale(.medium)
                                Text("\(k)").font(.subheadline.bold())
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(
                                (vm.peopleCount == k ? Color.white.opacity(0.22) : Color.white.opacity(0.10)),
                                in: Capsule()
                            )
                            .foregroundStyle(.white)
                        }
                    }

                    // More → numpad
                    Button {
                        if vm.totalText.isEmpty {
                            vm.bannerShown = true
                        } else {
                            vm.customPeopleText = "4"
                            vm.showCustomPeople = true
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "ellipsis.circle").imageScale(.medium)
                            Text("More").font(.subheadline.bold())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.10), in: Capsule())
                        .foregroundStyle(.white)
                    }
                }
                .padding(.top, 4)

                // Kısa ipucu satırı
                Text("Tip: You can also tilt your phone while splitting 😉")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top, 2)

                // Kapat
                Button {
                    withAnimation(.easeOut(duration: 0.18)) { vm.expandSplit = false }
                } label: {
                    Text("Close")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.14), in: Capsule())
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 12)

            }
            .frame(maxWidth: 360)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(radius: 24, y: 10)
            .padding(.horizontal, 20)
        }
        // Numpad sheet (overlay açıkken de çalışsın)
        .sheet(isPresented: $vm.showCustomPeople, onDismiss: {
            withAnimation(.easeOut(duration: 0.18)) { vm.expandSplit = false }
        }) {
            NavigationView {
                VStack(spacing: 16) {
                    Text("How many people?").font(.headline)
                    TextField("People", text: $vm.customPeopleText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.title.bold())
                        .padding()
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { vm.showCustomPeople = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            let val = max(1, min(Int(vm.customPeopleText) ?? vm.peopleCount, 99))
                            vm.peopleCount = val
                            vm.showCustomPeople = false
                        }
                    }
                }
            }
            .tint(.yellow)
            .presentationDetents([.height(dw(0.55)), .medium])
        }
    }

    private var splitSummaryView: some View {
        let total = Double(vm.totalText.replacingOccurrences(of: ",", with: ".")) ?? 0
        let per = vm.peopleCount > 0 ? total / Double(vm.peopleCount) : 0
       
        return Group {
            if vm.peopleCount > 1, total > 0 {
                VStack(spacing: 6) {
                    Text("BILL SPLIT")
                        .font(.footnote)
                        .foregroundStyle(ColorHandler.makeColor(.lightC))
                    
                    // Örn: 40 / 2 = 20 $ per each
                    HStack(spacing: 4) {
                        Text("\(vm.trimmedMoney(total))")
                            .font(.callout.bold())            // ⬅️ küçüldü
                            .foregroundStyle(.white)
                        Text("/")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("\(vm.peopleCount)")
                            .font(.callout.bold())            // ⬅️ küçüldü
                            .foregroundStyle(.white)
                        Text("=")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("\(vm.trimmedMoney(per)) \(vm.currency)")
                            .font(.callout.bold())            // ⬅️ küçüldü
                            .foregroundStyle(.green)
                        Text("per each")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
                }
            }
        }
    }

    
}
