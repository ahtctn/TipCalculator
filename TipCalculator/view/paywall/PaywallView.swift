//
//  PaywallView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 19.08.2025.
//

import SwiftUI
import RevenueCat

struct PaywallView: View {
    @StateObject private var vm = PaywallViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State private var showPrivacy = false
    @State private var showTerms = false

    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadPaywallView
            } else {
                iPhonePaywallView
            }
        }
        .background(Color.black.ignoresSafeArea(.all))
    }

}

//MARK: Device
extension PaywallView {
    private var iPadPaywallView: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            AnimatedBackgroundView()
            
            ScrollView {
                VStack(spacing: 10) {
                    topSection
                    advComposeView(dynWidth: 0.4)
                    productList
                    bottomSection
                }
                .padding()
                .cornerRadius(24)
                .padding()
            }
            .overlay(alignment: .topLeading) {
                if vm.xmarkVisible {
                    XMarkView {
                        homeVM.paywallShown = false
                    }
                }
            }
        }
        .onAppear {
            vm.pwAppeared()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                vm.xmarkVisible = true
            }
        }
        .onChange(of: vm.purchaseCompleted) { newValue, _ in
            if newValue {
                homeVM.paywallShown = false
            }
        }
        .sheet(isPresented: $showPrivacy) {
            NavigationStack {
                PrivacyPolicyView()
            }
        }
        .sheet(isPresented: $showTerms) {
            NavigationStack {
                TermsOfUseView()
            }
        }
    }

    
    private var iPhonePaywallView: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack {
                Spacer()
                topSection
                Spacer()
                advComposeView(dynWidth: 0.7)
                Spacer()
                productList
                Spacer()
                bottomSection
                
            }
            .padding(.vertical, dw(0.05))
            .overlay(alignment: .topLeading) {
                
                
                if vm.xmarkVisible {
                    XMarkView {
                        homeVM.paywallShown = false
                    }
                    
                }
            }
        }
        .onAppear {
            vm.pwAppeared()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                vm.xmarkVisible = true
            }
        }
        .onChange(of: vm.purchaseCompleted) { newValue, _ in
            if newValue {
                homeVM.paywallShown = false
            }
        }
        
        .sheet(isPresented: $showPrivacy) {
            NavigationStack {
                PrivacyPolicyView()
            }
        }
        .sheet(isPresented: $showTerms) {
            NavigationStack {
                TermsOfUseView()
            }
        }
    }
}


extension PaywallView {
    private var productList: some View {
        let is_iPad = UIDevice.current.userInterfaceIdiom == .pad
        return VStack(spacing: !is_iPad ? dw(0.045) : dw(0.02)) {
            
            ForEach(vm.availableProducts, id: \..self) { product in
                productCell(for: product)
            }
        }
    }
    
    private var topSection: some View {
        VStack {
            AngryHeadShakeView(speed: 0.4, width: 0.3,
                               img: .applogo
            )
        
            
            Text("Tip Calculator+")
                .font(.system(size: 27, weight: .bold, design: .monospaced))
                .foregroundStyle(LinearGradient(colors: [
                    .orange,
                    .yellow
                ], startPoint: .bottomLeading, endPoint: .topTrailing))
        }
    }
    
    private func productCell(for product: StoreProduct) -> some View {
        let isSelected = product.productIdentifier == vm.selectedProductID
        let title = localizedTitle(for: product)
        let is_iPad = UIDevice.current.userInterfaceIdiom == .pad
        return Button {
            vm.selectedProductID = product.productIdentifier
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    
                    AnyShapeStyle(
                        LinearGradient(
                            gradient: Gradient(colors: isSelected ? [Color.orange, Color.yellow] : [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                )
                .frame(width: dw(0.9), height: !is_iPad ? dw(0.2) : dw(0.1))
                .customShadow()
                .overlay(
                    ZStack {
                        // ✨ Stroke sadece seçiliyse gösterilsin
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? .orange : .yellow, lineWidth: 1.5)
                        
                        // 💬 İçerik: fiyat, başlık vs
                        HStack {
                            VStack(alignment: .leading, spacing: dw(0.02)) {
                                Text(title)
                                    .font(.system(size: 23)).bold()
                                    .foregroundStyle(
                                        isSelected
                                        ? LinearGradient(
                                            colors: [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)],
                                            startPoint: .bottomLeading,
                                            endPoint: .topTrailing
                                        )
                                        : LinearGradient(
                                            colors: [Color.orange, Color.yellow],
                                            startPoint: .bottomLeading,
                                            endPoint: .topTrailing
                                        )
                                    )

                            }

                            Spacer()

                            // ⬇️ SADECE YILLIK İÇİN ÖZEL FİYAT BLOĞU
                            if isYearly(product) {
                                VStack(alignment: .trailing, spacing: 6) {
                                    // üstü çizili ilk fiyat + %80 OFF rozeti
                                    HStack(spacing: 8) {
                                        Text("80% OFF")
                                            .font(.caption2.bold())
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(
                                                Capsule().fill(Color.red.opacity(0.95))
                                                    .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 0.5))
                                            )
                                            .foregroundStyle(.white)
                                        if let original = originalPriceString(for: product) {
                                            Text(original)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundStyle(isSelected ? Color.black : .white.opacity(0.65))
                                                .strikethrough(true, color: isSelected ? Color.black : .white.opacity(0.65))
                                                .fixedSize()
                                        }
                                    }

                                    // güncel fiyat
                                    Text(product.localizedPriceString)
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundStyle( isSelected ? ColorHandler.makeColor(.bg1) : .orange)
                                }
                            } else {
                                // Diğer planlar için mevcut görünüm
                                VStack {
                                    Text(product.localizedPriceString)
                                        .font(.system(size: 22, weight: .heavy))
                                        .foregroundStyle( isSelected ? ColorHandler.makeColor(.bg1) : .orange)
                                    
                                    HStack(spacing: 8) {
                                        Text("3 days OFF!")
                                            .font(.caption2.bold())
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 8)
                                            .background(
                                                Capsule().fill(
                                                    LinearGradient(colors: [
                                                        .blue, .mint
                                                    ], startPoint: .bottomLeading, endPoint: .topTrailing)
                                                )
                                                    .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 0.5))
                                            )
                                            .foregroundStyle(ColorHandler.makeColor(.bg2))
                                        
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)

                    }
                )
        }
    }
    
    
    private var bottomSection: some View {
        VStack(spacing: dw(0.04)) {
            
            DefaultButton(title: vm.isPurchasing ? "" : "Premium Features", iconName: vm.isPurchasing ? "" : "wallet.bifold", action: {
                vm.purchaseProduct(productID: vm.selectedProductID) { success in
                    if success {
                        homeVM.paywallShown = false
                    }
                }
            })
            .overlay {
                if vm.isPurchasing {
                    ProgressView().tint(Color.gray)
                }
            }
            bottomButtonSectionView
        }
    }
    
    private var bottomButtonSectionView: some View {
        HStack {
            bottomButton("Terms") {
                showTerms = true
            }
            Spacer()
            bottomButton("Restore") {
                vm.restorePurchases()
            }
            Spacer()
            bottomButton("Privacy") {
                showPrivacy = true
            }
        }
        .padding(.horizontal, dw(0.08))
    }

    
    private func bottomButton(_ txt: String, _ act: @escaping () -> ()) -> some View {
        Button(action: act) {
            Text(txt)
                .font(.system(size: 15))
                .bold()
                .foregroundStyle(Color.orange.opacity(0.8))
        }
    }
    
    private func advComposeView(dynWidth: Double) -> some View {
        let is_iPad = UIDevice.current.userInterfaceIdiom == .pad
        return RoundedRectangle(cornerRadius: 24)
            .fill(Color.black.opacity(0.5))
            .frame(width: dw(0.8), height: dw(dynWidth))
            .overlay {
                VStack(alignment: .leading, spacing: !is_iPad ?  dw(0.03) : dw(0.01)) {
                    AdvantageRow(
                        iconName: "arrow.triangle.2.circlepath",
                        title: "Exclusive Physics Play",
                        subtitle: "Dynamic gravity — tilt your phone and watch circles roll.",
                        c1: Color.orange,
                        c2: Color.yellow,
                    )
                    
                    AdvantageRow(
                        iconName: "dice",
                        title: "Unlimited Rolls",
                        subtitle: "Drop as many balls as you want and test your luck.",
                        c1: Color.yellow,
                        c2: Color.red
                    )
                    
                    AdvantageRow(
                        iconName: "lightbulb",
                        title: "Smart Tips",
                        subtitle: "Enter custom tips or get instant random suggestions.",
                        c1: .blue,
                        c2: .green
                    )
                }
                .padding(10)
            }
    }
    
    
    private func localizedTitle(for product: StoreProduct) -> String {
        switch product.productIdentifier {
        case "tip_yearly_2499":
            return "Yearly"
        case "tip_weekly_499_3df":
            return "Weekly"
        default:
            return product.localizedTitle
        }
    }
    
    private func isYearly(_ product: StoreProduct) -> Bool {
        product.productIdentifier == "tip_yearly_2499"
    }
    
    /// Mevcut fiyattan %80 indirim öncesi "ilk fiyat"ı üretir (yani current / 0.2)
    private func originalPriceString(for product: StoreProduct, discountRate: Double = 0.80) -> String? {
        // RevenueCat StoreProduct.price -> Decimal
        let current = NSDecimalNumber(decimal: product.price)
        // %80 indirim -> müşteri %20 öder
        let original = current.dividing(by: NSDecimalNumber(value: 1.0 - discountRate))

        // Varsa ürünün kendi formatter'ı/currencyCode'unu kullan
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        if let code = product.currencyCode { fmt.currencyCode = code }
        fmt.locale = Locale.current
        return fmt.string(from: original)
    }
}

