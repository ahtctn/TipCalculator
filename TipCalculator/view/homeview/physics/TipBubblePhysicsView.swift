//
//  TipBubblePhysicsView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SwiftUI
import SpriteKit
import SwiftUI
import SpriteKit

struct TipBubblePhysicsView: UIViewRepresentable {
    var onTap: (Int) -> Void
    var isInteractionEnabled: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        skView.allowsTransparency = true

        let scene = PhysicsScene()
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .resizeFill
        scene.onBubbleTap = onTap
        scene.isInteractionEnabled = isInteractionEnabled

        let percents = [10, 15, 20, 25, 30]
        var usedX: [CGFloat] = []

        for percent in percents {
            let radius = CGFloat(percent) * 3
            var x: CGFloat
            var attempt = 0

            repeat {
                x = CGFloat.random(in: radius...(scene.size.width - radius))
                attempt += 1
            } while usedX.contains(where: { abs($0 - x) < radius * 2 }) && attempt < 30

            usedX.append(x)
            let yStart = scene.size.height - 150

            scene.addBubble(
                percent: percent,
                radius: radius,
                position: CGPoint(x: x, y: yStart + CGFloat.random(in: -30...30))
            )
        }

        context.coordinator.scene = scene // 👈 scene'i saklıyoruz
        skView.presentScene(scene)
        return skView
    }

    func updateUIView(_ uiView: SKView, context: Context) {
        context.coordinator.scene?.isInteractionEnabled = isInteractionEnabled
    }

    class Coordinator {
        var scene: PhysicsScene?
    }
}
