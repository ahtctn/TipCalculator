//
//  DefaultBannerView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 1.07.2025.
//


import Lottie
import SwiftUI

struct DefaultBannerView: View {
    let anim: String
    let txt: String
    var act: () -> ()
    var body: some View {
        ZStack {
            ColorHandler.makeColor(.txtC)
                .opacity(0.6)
                .onTapGesture {
                    act()
                }
            RoundedRectangle(cornerRadius: 24)
                .stroke(ColorHandler.makeColor(.lightC), lineWidth: 1.5)
                .frame(width: dw(0.91), height: dw(0.5))
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(colors: [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)], startPoint: .bottomLeading, endPoint: .topTrailing)
                        )
                        .overlay {
                            VStack {
                                LottieAnimationManager(name: anim, loopMode: .loop)
                                    .frame(width: dw(0.2), height: dw(0.2))
                                Text(txt)
                                    .foregroundStyle(ColorHandler.makeColor(.lightC))
                                
                                DefaultButton(title: "OK", iconName: "checkmark") {
                                    act()
                                }
                            }
                        }
                    
                }
        }.ignoresSafeArea(.all)
        
    }
}
