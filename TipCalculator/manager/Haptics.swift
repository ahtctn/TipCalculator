//
//  Haptics.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.09.2025.
//


import UIKit

final class Haptics {
    static let shared = Haptics()

    private let pinImpact = UIImpactFeedbackGenerator(style: .soft)
    private let boxImpact = UIImpactFeedbackGenerator(style: .light)
    private let note = UINotificationFeedbackGenerator()

    private var lastPinTick: CFTimeInterval = 0
    private let pinMinInterval: CFTimeInterval = 0.06 // ~60ms, abartısız

    private init() {
        pinImpact.prepare()
        boxImpact.prepare()
        note.prepare()
    }

    func tickPin(now: CFTimeInterval = CACurrentMediaTime()) {
        guard now - lastPinTick > pinMinInterval else { return }
        lastPinTick = now
        pinImpact.impactOccurred(intensity: 0.4) // çok hafif
    }

    func tripleOnBox() {
        // 3 minik dokunuş (blocking değil, main kuyruğa aralıklı atıyoruz)
        boxImpact.impactOccurred(intensity: 0.7)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) { [weak self] in
            self?.boxImpact.impactOccurred(intensity: 0.7)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) { [weak self] in
            self?.boxImpact.impactOccurred(intensity: 0.7)
        }
    }

    func success() { note.notificationOccurred(.success) }
}
