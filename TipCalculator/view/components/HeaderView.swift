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
    var isIconVisible: Bool
    var isDoneButtonVisible: Bool
 
    var historyIcon: String
    var isHistoryVisible: Bool
    var history_act: () -> ()

    var act: () -> ()
    var pro_act: () -> ()
    var done_act: () -> ()
    
    init(
        name: String = "Tip Calculator",
        icon: String = "gearshape",
        isIconV: Bool = true,
        isDoneV: Bool = false,
        isHistoryVisible: Bool = true,
        act: @escaping () -> Void,
        pro_act: @escaping () -> Void,
        done_act: @escaping () -> Void,
        historyIcon: String = "clock.arrow.circlepath",
        
        history_act: @escaping () -> Void = {}
    ) {
        self.name = name
        self.icon = icon
        self.isIconVisible = isIconV
        self.isDoneButtonVisible = isDoneV
        self.act = act
        self.pro_act = pro_act
        self.done_act = done_act

        self.historyIcon = historyIcon
        self.isHistoryVisible = isHistoryVisible
        self.history_act = history_act
    }
    
    var body: some View {
        HStack {
            HStack(spacing: dw(0.04)) {
                ImageHandler.makeImage(.applogo)
                    .frame(width: dw(0.08), height: dw(0.08))
                    .customShadow()
                Text(name)
                    .font(.system(size: 16, weight: .heavy))
            }
            Spacer()

            if AccessControlManager.shouldShowPaywall() {
                ProButtonView { pro_act() }
            }

            HStack(spacing: dw(0.04)) {
                // ⚙️ Settings (mevcut)
                if isIconVisible {
                    Button { act() } label: {
                        Image(systemName: icon)
                            .frame(width: dw(0.08), height: dw(0.08))
                            .foregroundStyle(ColorHandler.makeColor(.lightC))
                    }
                }

                // 🕘 History (yeni, gear’ın hemen yanında)
                if isHistoryVisible {
                    Button { history_act() } label: {
                        Image(systemName: historyIcon)
                            .frame(width: dw(0.08), height: dw(0.08))
                            .foregroundStyle(ColorHandler.makeColor(.lightC))
                    }
                    .accessibilityLabel("History")
                }

                if isDoneButtonVisible {
                    Button { done_act() } label: {
                        Text("Done").bold()
                            .foregroundStyle(ColorHandler.makeColor(.lightC))
                    }
                }
            }
        }
        .foregroundStyle(ColorHandler.makeColor(.lightC))
        .padding([.horizontal, .top], dw(0.05))
    }
}

#Preview {
    HeaderView(
        act: {},
        pro_act: {},
        done_act: {},
        history_act: {}
    )
}

