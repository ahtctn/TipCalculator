//
//  TransparentSpriteView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import UIKit
import SwiftUI
import SpriteKit

struct TransparentSpriteView: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = .clear
        skView.allowsTransparency = true
        skView.presentScene(scene)
        return skView
    }
    
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}
