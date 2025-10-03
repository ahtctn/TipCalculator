//
//  NotificationManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//


//
//  NotificationManager.swift
//  Roaster
//
//  Created by Ahmet Ali ÇETİN on 19.08.2025.
//

import SwiftUI
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private let notificationScheduledKey = "hasScheduledDailyNotification"

    private init() {}

    static func request(_ completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                completion(granted)
            }
    }

    func scheduleDailyNotificationWithRandomCompose() {
        cancelAllNotifications() // daha önce varsa iptal et

        let content = UNMutableNotificationContent()
        content.title = fetchRandomTitle()
        content.body = fetchRandomComposeBody()
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily_compose_question",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Bildirim zamanlama hatası: \(error.localizedDescription)")
            } else {
                print("📆 Günlük 20:30 bildirimi zamanlandı.")
            }
        }
    }


    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func fetchRandomTitle() -> String {
        let titles = [
            "💰 Tip Quest Unlocked!",
            "🎲 Dice Rolled, Bill Calculated!",
            "🔥 Your Wallet Just Got Spicy!",
            "👑 You’re the Tip Master!",
            "🎯 Bullseye! Perfect Split!",
            "⚡ Critical Hit on the Bill!",
            "🎉 Jackpot Calculation!",
            "🧩 Puzzle Solved: Tip Edition",
            "🚀 Tip Boost Activated!",
            "🏆 Level Up: Bill Boss!"
        ]
        return titles.randomElement() ?? "✨ Random Tip Magic!"
    }


    
    func fetchRandomComposeBody() -> String {
        let bodies = [
            "Your meal just leveled up with the perfect tip combo. 🍔➡️💸",
            "You split the bill like a pro ninja! ⚔️",
            "That calculation was smoother than your latte foam. ☕",
            "Boom! The check doesn’t stand a chance. 💥",
            "Another round? You’ve got the math covered. 🍻",
            "Math + Money = Victory Dance unlocked. 🕺",
            "Bill conquered, wallet respected. 🎖️",
            "This tip is so sharp, it could cut onions. 🔪🧅",
            "Balance restored. Guests are happy, you’re the hero. 🦸",
            "The crowd cheers: ‘One more calculation!’ 📣"
        ]
        return bodies.randomElement() ?? "✨ Surprise tip text appears!"
    }


}
