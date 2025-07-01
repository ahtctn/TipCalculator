//
//  LottieAnimationManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import Foundation
import Lottie
import SwiftUI
import UIKit

struct LottieAnimationManager: UIViewRepresentable {
    typealias UIViewType = UIView
    
    let name: String
    let loopMode: LottieLoopMode
    var speed: CGFloat?
    
    func makeUIView(context: UIViewRepresentableContext<LottieAnimationManager>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView(
            name: name,
            configuration: LottieConfiguration(renderingEngine: .mainThread)
        )
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed ?? 1.0
        DispatchQueue.global(qos: .userInitiated).async {
            animationView.play()
        }

        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieAnimationManager>) {
        
    }
}
