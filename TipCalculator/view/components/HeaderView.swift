//
//  HeaderView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SwiftUI

struct HeaderView: View {
    let name: String
    
    var icon: String
    var act: () -> ()
    var pro_act: () -> ()
    
    init(name: String = "Tip Calculator",
         icon: String = "gearshape",
         act: @escaping () -> Void,
         pro_act: @escaping () -> Void
    )
    {
        self.name = name
        self.icon = icon
        self.act = act
        self.pro_act = pro_act
    }
    
    
    var body: some View {
        HStack {
            HStack(spacing: dw(0.08)) {
                ImageHandler.makeImage(.applogo)
                    .frame(width: dw(0.08), height: dw(0.08))
                    .customShadow()
                Text(name)
                    .font(.system(size: 22, weight: .heavy))
            }
            Spacer()
            if AccessControlManager.shouldShowPaywall() {
                ProButtonView {
                    pro_act()
                }
            }
            Image(systemName: icon)
                .frame(width: dw(0.08), height: dw(0.08))
        }
        .foregroundStyle(ColorHandler.makeColor(.lightC))
        .padding(.horizontal)
        .padding(.top, dw(0.05))
    }
}

#Preview {
    HeaderView {
        
    } pro_act: {}
}
