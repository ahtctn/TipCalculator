//
//  NotificationsPage.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//


import UserNotifications
import SwiftUI
import Lottie

struct NotificationsPage: View {
    var onFinish: () -> Void
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    @State private var statusText = "Get alerts when your joke is ready, new styles drop, and more."

    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            VStack(spacing: dw(0.061)) {
                header(title: "Enable Notifications" ,
                       subtitle: statusText,
                       tip: "You can change this anytime in Settings.")
                
                Spacer()
                notifAdvantages
                LottieAnimationManager(name: "notifications", loopMode: .loop)
                    .frame(width: dw(!isPad ? 0.3 : 0.2), height: dw(!isPad ? 0.3 : 0.2))
                Spacer()
                // ✅ DefaultButton
                DefaultButton(title: "Allow" ,
                              iconName: "bell.and.waves.left.and.right") {
                    NotificationManager.request { granted in
                        DispatchQueue.main.async {
                            statusText = granted
                            ?
                            "Nice! You'll never miss a tip." : "No worries—jokes will still be here when you are."
                            onFinish()
                        }
                    }
                }
                              .padding(.horizontal, dw(0.04))
                              .padding(.bottom, dw(0.02))
                
            }
            .padding(.top, dw(0.061))
        }
    }
}

extension NotificationsPage {
    private var notifAdvantages: some View {
        VStack(spacing: dw(0.035)) {
            SectionCard(
                iconName: "star.fill",
                title: "Special Offers",
                subtitle: "Get notified about exclusive deals and premium joke packs.",
                strokeColor: .yellow
            )
            SectionCard(
                iconName: "sparkles",
                title: "New Features",
                subtitle: "Be the first to try out new joke styles and fresh updates.",
                strokeColor: .red
            )
            SectionCard(
                iconName: "flame.fill",
                title: "Joke Reminders",
                subtitle: "Never miss a chance to crack a joke with friendly reminders.",
                strokeColor: .yellow
            )
        }
        .padding(.horizontal, dw(0.04))
    }
}

import SwiftUI

@ViewBuilder
func header(title: String, subtitle: String, tip: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        Text(title)
            .font(.system(size: 34, weight: .heavy))
            .foregroundStyle(.white)
        Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.7))
        Text(tip)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.orange)
            .padding(.top, 4)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
    }
    .padding(.horizontal, 16)
}
