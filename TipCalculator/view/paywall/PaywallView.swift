//
//  PaywallView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//

import Foundation

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
    }

}

//MARK: Device
extension PaywallView {
    private var iPadPaywallView: some View {
        ZStack {
            AnimatedBackgroundView()
            
            ScrollView {
                VStack(spacing: 32) {
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
                advComposeView(dynWidth: 0.6)
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
        VStack(spacing: dw(0.045)) {
            
            ForEach(vm.availableProducts, id: \..self) { product in
                productCell(for: product)
            }
        }
    }
    
    private var topSection: some View {
        VStack {
            ImageHandler.makeImage(.applogo)
                .resizable()
                .frame(width: dw(0.2544), height: dw(0.2544))
                .cornerRadius(24)
                .customShadow()
            Text("Tip Calculator +")
                .font(.system(size: 34)).bold()
                .foregroundStyle(ColorHandler.makeColor(.lightC))
                .multilineTextAlignment(.center)
        }
    }
    
    private func productCell(for product: StoreProduct) -> some View {
        let isSelected = product.productIdentifier == vm.selectedProductID
        let title = localizedTitle(for: product)
        
        return Button {
            vm.selectedProductID = product.productIdentifier
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    AnyShapeStyle(LinearGradient(gradient: Gradient(colors: [ColorHandler.makeColor(.bg1), ColorHandler.makeColor(.bg2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                )
                .frame(width: dw(0.9), height: dw(0.2))
                .customShadow()
                .overlay(
                    ZStack {
                        // ✨ Stroke sadece seçiliyse gösterilsin
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorHandler.makeColor(.lightC), lineWidth: 1.5)
                        }
                        
                        // 💬 İçerik: fiyat, başlık vs
                        HStack {
                            VStack(alignment: .leading, spacing: dw(0.035)) {
                                Text(title)
                                    .font(.system(size: 21)).bold()
                                
                                if let introPrice = product.localizedIntroductoryPriceString {
                                    Text("\(introPrice)")
                                        .font(.system(size: 15))
                                        .padding(.all, dw(0.012))
                                        .background(ColorHandler.makeColor(.bg1))
                                        .cornerRadius(dw(0.0152))
                                }
                            }
                            .foregroundStyle(ColorHandler.makeColor(.lightC))
                            Spacer()
                            
                            VStack {
                                Text(product.localizedPriceString)
                                    .font(.system(size: 21)).bold()
                                    .foregroundStyle(isSelected ? ColorHandler.makeColor(.bg1) : Color.white)
                            }
                        }
                        .padding(.horizontal)
                    }
                )
        }
    }
    
    
    private var bottomSection: some View {
        VStack(spacing: dw(0.08)) {
            
            DefaultButton(title: vm.isPurchasing ? "" : "Satın Al", iconName: vm.isPurchasing ? "" : "wallet.bifold", action: {
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
        .padding(.bottom, dw(0.08))
    }
    
    private var bottomButtonSectionView: some View {
        HStack {
            bottomButton("Kullanım Koşulları") {
                showTerms = true
            }
            Spacer()
            bottomButton("Yenile") {
                vm.restorePurchases()
            }
            Spacer()
            bottomButton("Gizlilik") {
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
                .foregroundStyle(ColorHandler.makeColor(.lightC).opacity(0.7))
        }
    }
    
    private func advComposeView(dynWidth: Double) -> some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.black.opacity(0.5))
            .frame(width: dw(0.8), height: dw(dynWidth))
            .overlay {
                VStack(alignment: .leading, spacing: dw(0.045)) {
                    AdvantageRow(
                        iconName: "nosign",
                        title: "Reklamsız Deneyim",
                        subtitle: "Tek bir reklam bile yok."
                    )

                    AdvantageRow(
                        iconName: "infinity",
                        title: "Süresiz Kullanım",
                        subtitle: "Bir kere öde, hep seninle."
                    )
                }
                .padding(10)
            }
    }
    
    private func localizedTitle(for product: StoreProduct) -> String {
        switch product.productIdentifier {
        case "rc_1299_lifetime":
            return "Tek Seferlik"
        default:
            return product.localizedTitle
        }
    }
}

