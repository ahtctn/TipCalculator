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
                
                gameboxView

                Spacer()
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
    private var rollDiceView: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(vm.rollCount >= 10 ? Color.green.opacity(0.2) : Color.white.opacity(0.2))
            .frame(width: dw(0.5))
            .overlay(
                diceComponents
            )
            .frame(height: dw(0.1526))
    }
    
    private var diceIcon: some View {
        Button {
            if vm.totalText == "" {
                vm.bannerShown = true
            } else {
                vm.rollDice()
            }
            
        } label: {
            Image(systemName: "die.face.4")
                .font(.title)
                .padding()
                .background(Circle().stroke(vm.isRandomTipActive ? Color.green : ColorHandler.makeColor(.lightC), lineWidth: 3))
                .foregroundStyle(vm.isRandomTipActive ? Color.green : ColorHandler.makeColor(.lightC))
        }.disabled(vm.isRolling)
    }
    
    private var percentSection: some View {
        VStack(alignment: .leading) {
            Text("RANDOM TIP")
                .font(.footnote)
                .foregroundStyle(ColorHandler.makeColor(.lightC))
            Text("\(vm.tipPercent)%")
                .font(.title3.bold())
                .foregroundStyle(vm.rollCount >= 10 ? .green : ColorHandler.makeColor(.lightC))
                .padding(.trailing, 12)
        }
    }
    
    private var diceComponents: some View {
        HStack(spacing: 12) {
            diceIcon
            
            percentSection
        }
    }
    
    private var gameboxView: some View {
        Button {
            if vm.totalText == "" {
                vm.bannerShown = true // 💯 Artık çalışacak
            } else {
                vm.presentGameBox = true
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "gamecontroller.fill").imageScale(.large)
                Text("Game Box").bold()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial, in: Capsule())
            .foregroundStyle(Color.orange)
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
            rollDiceView
            
            Spacer()
            
            customTipTextField
        }
        .padding(.horizontal)
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
            Text("$")
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
        TextField("Price", text: $vm.totalText)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.center)
            .font(.system(size: 40, weight: .bold))
            .foregroundStyle(.white)
            .onTapGesture {
                // İlk tıklamada temizle
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
}
