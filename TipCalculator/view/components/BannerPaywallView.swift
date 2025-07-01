//
//  BannerPaywallView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI

struct BannerPaywallView: View {
    var act: () -> ()
    
    init(act: @escaping () -> ()) {
        self.act = act
    }
    
    var body: some View {
        ZStack {
            Button {
                act()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorHandler.makeColor(.bg2))
                    .frame(width: dw(0.88), height: dw(0.18))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ColorHandler.makeColor(.bg1).opacity(0.5), lineWidth: 3)
                        HStack(spacing: dw(0.0407)) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Tip Calculator +")
                                    .font(.system(size: 16)).bold()
                                    .foregroundStyle(ColorHandler.makeColor(.lightC))
                                Text("Reklamsız ve sınırsız erişim!")
                                    .font(.system(size: 12))
                                    .foregroundStyle(ColorHandler.makeColor(.lightC))
                            }
                            .foregroundStyle(ColorHandler.makeColor(.bg1))
                            Button {
                                act()
                            } label: {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(ColorHandler.makeColor(.lightC), lineWidth: 1.5)
                                    .frame(width: dw(0.292), height: dw(0.0923))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(ColorHandler.makeColor(.lightC), lineWidth: 2.5)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(
                                                        LinearGradient(gradient: Gradient(colors: [ColorHandler.makeColor(.bg2), ColorHandler.makeColor(.bg1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                                    )
                                                    .overlay {
                                                        Text("PRO")
                                                            .foregroundStyle(ColorHandler.makeColor(.lightC))
                                                            .font(.system(size: 16))
                                                    }
                                            }
                                    }
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    BannerPaywallView {
    }
}
