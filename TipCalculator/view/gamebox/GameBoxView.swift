//
//  GameBoxView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.09.2025.
//

import SwiftUI
import SpriteKit
import Combine

struct GameBoxView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @StateObject private var bridge = SceneBridge()
    @State private var scene = PlinkoScene(size: UIScreen.main.bounds.size)
    @State private var animateShine = false
    @State private var countdown: Int? = nil
    @State private var countdownTimer: Timer? = nil
    @State private var animatedTotal: Double? = nil
    @State private var baseAtLanding: Double = 0

    var body: some View {
        ZStack {
            AnimatedBackgroundView().ignoresSafeArea()
            spriteSection
                
            VStack {
                slotTitleSection
                slotPayoutSection
            }
            countdownSection
            
            totalBadgeSection
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: bridge.landingText)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: countdown)
        .onAppear {
            scene.scaleMode = .resizeFill
            scene.bridge = bridge
            scene.bootIfNeeded()
        }
        .onDisappear {
            countdownTimer?.invalidate()
            countdownTimer = nil
            countdown = nil
            bridge.landingText = nil
            scene.resetAll()

            if let p = bridge.landingPercent {
                homeVM.selectedPercent = p
                homeVM.tipPercent = p
                homeVM.commitSelectionToHomeIfNeeded(percent: p)
            }
        }
        
        .onChange(of: bridge.landingPercent) { newP, _ in
            guard let p = newP, baseAtLanding > 0 else { return }

            let target = baseAtLanding * (1.0 + Double(p)/100.0)
 
            // ✅ sadece ekranda animasyonlu göster
            animatedTotal = baseAtLanding
            withAnimation(.easeOut(duration: 0.9)) {
                animatedTotal = target
            }
        }
        .overlay {
            dropButtonSection
        }
    }
    
    private var buttonTitle: String {
        if countdown != nil { return "Get Ready…" }
        return bridge.isBallActive ? "Ball in play…" : "Drop"
    }
    
    private var creditBtn: some View {
        Group {
            if AccessControlManager.shouldShowPaywall() {
                Button {
                    homeVM.presentGameBox = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        homeVM.paywallShown = true
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)

                        Text("\(homeVM.credits)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(width: dw(0.1), height: dw(0.03))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.yellow, lineWidth: 2)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.6))
                            )
                    )
                    .shadow(color: Color.yellow.opacity(0.4), radius: 6, x: 0, y: 4)
                }
            }
        }
        
    }
    
    private func startCountdownAndDrop() {
        guard countdown == nil, bridge.isBallActive == false else { return }

        let base = inputBase()
        guard base > 0 else {
            homeVM.bannerShown = true
            return
        }
        baseAtLanding = base

        // 👇 yeni top: ekrandaki tüm sonuçları temizle
        bridge.landingText = nil
        bridge.landingPercent = nil
        animatedTotal = nil

        countdown = 3
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            guard let c = countdown else { return }
            if c > 1 {
                countdown = c - 1
            } else {
                t.invalidate()
                countdownTimer = nil
                countdown = nil
                scene.dropBall()
                homeVM.decreaseCredit()
            }
        }
    }


    private func inputBase() -> Double {
        // Sadece text’ten oku (locale virgül -> nokta düzeltmesi)
        let raw = homeVM.totalText.replacingOccurrences(of: ",", with: ".")
        return Double(raw) ?? 0
    }
    
    


}


#Preview {
    GameBoxView()
}

extension GameBoxView {
    private var xmarkSection: some View {
        Button {
            homeVM.presentGameBox = false
        } label: {
            Image(systemName: "xmark")
                .font(.system(size: 24, weight: .bold))
                .padding()
                .foregroundColor(ColorHandler.makeColor(.lightC))
        }
        .zIndex(2)
    }
    
    private var spriteSection: some View {
        TransparentSpriteView(scene: scene)
            .ignoresSafeArea()
        
    }
    
    
    
    // sağ üst total rozet
    private var totalBadgeSection: some View {
        VStack {
            HStack {
                xmarkSection
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    creditBtn
                    totalSection
                }
            }
            Spacer()
            
        }
        .zIndex(2)
        
    }
 
    private var slotPayoutSection: some View {
        Group {
            if let p = bridge.landingPercent, baseAtLanding > 0 {
                let multiplier   = 1.0 + Double(p)/100.0
                let tipTarget    = baseAtLanding * Double(p)/100.0
                let targetTotal  = baseAtLanding * multiplier
                let currentTotal = animatedTotal ?? baseAtLanding

                VStack(spacing: 8) {
                    // 🔵 ÜST: ÖDENECEK TOPLAM (animasyonlu)
                    Text("$\(targetTotal, specifier: "%.2f")")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .shadow(color: .pink.opacity(0.6), radius: 10)
                        .contentTransition(.numericText())
                        .transition(.scale.combined(with: .opacity))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)

                    // ⚪️ ALT 1: "100 % 50"
                    Text(String(format: "%.2f  %% %d", baseAtLanding, p))
                        .font(.title3.weight(.heavy))
                        .foregroundStyle(.white.opacity(0.95))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    // 🟣 ALT 2: Tip satırı
                    Text(String(format: "+ $%.2f tip", tipTarget))
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(.white.opacity(0.9))
                        .monospacedDigit()

                    // 🔸 ALT 3: Açıklama satırı
                    Text(String(format: "%.2f × %.2f = %.2f",
                                baseAtLanding, multiplier, targetTotal))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .monospacedDigit()
                }
                .padding(.top, 12)
            }
        }
    }

    private var totalSection: some View {
        HStack(spacing: 6) {
            Text("TOTAL")
                .font(.caption.bold())
                .foregroundStyle(.mint.opacity(0.9))

            Text(formatDisplayAmount(homeVM.totalText))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.mint, lineWidth: 1.5)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black.opacity(0.45))
                )
        )
        .shadow(color: .mint.opacity(0.25), radius: 6, x: 0, y: 3)
        .padding(.trailing, 10)
        .padding(.top, 5)
    }
    
    private var slotTitleSection: some View {
        Group {
            if let text = bridge.landingText {
                Text(text)
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24).padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .pink.opacity(0.8), radius: 18, x: 0, y: 0)  // 🔥 neon
                    .shadow(color: .white.opacity(0.5), radius: 6, x: 0, y: 0)
                    .scaleEffect(1.06)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.interpolatingSpring(stiffness: 220, damping: 18), value: bridge.landingText)
                    .overlay(
                        // parıltı şeridi
                        LinearGradient(colors: [.clear, .white.opacity(0.35), .clear],
                                       startPoint: .leading, endPoint: .trailing)
                        .blendMode(.screen)
                        .mask(
                            RoundedRectangle(cornerRadius: 24).fill(Color.white)
                                .frame(height: 6)
                                .offset(y: -22)
                                .offset(x: animateShine ? 200 : -200)
                        )
                    )
                    .onAppear { animateShine.toggle() }
            }
        }
    }
    
    
    
    private var countdownSection: some View {
        Group {
            if let c = countdown {
                Text("\(c)")
                    .font(.system(size: 90, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(radius: 16)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    private var dropButtonSection: some View {
        VStack {
            Spacer()
            Button {
                if AccessControlManager.shouldShowPaywall() && homeVM.credits <= 0 {
                    homeVM.presentGameBox = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        homeVM.paywallShown = true
                    }
                } else {
                    startCountdownAndDrop()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "play.circle.fill").imageScale(.large)
                    Text(buttonTitle)
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
            }
            .disabled(bridge.isBallActive || countdown != nil)
            .padding(.bottom, 24)
            .foregroundStyle(.orange)
            Spacer().frame(height: dw(0.25))
        }
        .padding(dw(0.035))
        .opacity(!bridge.isBallActive ? 1 : 0.00000001)
    }
    
    func formatDisplayAmount(_ text: String) -> String {
        if let value = Double(text) {
            let intPart = Int(value)
            if value == Double(intPart) {
                return "\(homeVM.currency)\(intPart)"
            } else {
                return String(format: "\(homeVM.currency)%.2f", value)
            }
        }
        return "$\(text)"
    }

}
