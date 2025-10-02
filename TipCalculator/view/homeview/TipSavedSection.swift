//
//  TipSavedSection.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 2.10.2025.
//


import SwiftUI
import Lottie

struct TipSavedSection: View {
    @EnvironmentObject var vm: HomeViewModel
    
    var body: some View {
        ZStack {
            // 🔹 Arkaplan
            AnimatedBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 18) {
                // Actions (üst)
                upperSectionView
                
                LottieAnimationManager(name: "ob1", loopMode: .loop)
                    .frame(height: dw(0.5))
                
                VStack(spacing: 6) {
                    Text("Tip Saved")
                        .font(.title.bold())
                        .foregroundStyle(.primary)
                    Text("Your calculation has been saved to history.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                // Title alanı
                VStack(alignment: .leading, spacing: 8) {
                    Text("TITLE")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    TextField("Add a title…", text: $vm.tipSavedTitleDraft)
                        .textInputAutocapitalization(.sentences)
                        .submitLabel(.done)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal)
                
                // Özet kartı
                summaryCard
                
                Spacer()
            }
        }
    }
    
    private var summaryCard: some View {
        let cleaned = Double(vm.totalText.replacingOccurrences(of: ",", with: ".")) ?? 0
        let percent = vm.selectedPercent ?? (vm.customTipPercent > 0 ? vm.customTipPercent : (vm.isRandomTipActive ? vm.tipPercent : 0))
        let tip = cleaned - vm.baseAmount // ✅ total - base
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Summary", systemImage: "doc.text.magnifyingglass")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(vm.currency)
                    .font(.subheadline.monospaced())
                    .foregroundStyle(.secondary)
            }
            
            row("Base", "\(vm.trimmedMoney(vm.baseAmount)) \(vm.currency)")
            row("Percent", "%\(percent)")
            row("Tip", "\(vm.trimmedMoney(tip)) \(vm.currency)")
            row("Total", "\(vm.trimmedMoney(cleaned)) \(vm.currency)")
            if vm.peopleCount > 1 {
                let per = cleaned / Double(vm.peopleCount)
                row("Per Person", "\(vm.trimmedMoney(per)) \(vm.currency)")
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.horizontal)
    }
    
    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary.opacity(0.9)) // subtitle ~0.8–0.9
            Spacer()
            Text(value)
                .font(.callout.weight(.semibold))
        }
    }
}

extension TipSavedSection {
    private var upperSectionView: some View {
        HStack(spacing: 12) {
            Button {
                vm.persistSavedTitle()
                vm.showTipSavedSection = false
            } label: {
                Label("Save Title", systemImage: "checkmark.circle.fill")
                    .font(.headline).bold()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.orange, in: Capsule())
                    .foregroundStyle(.white)
            }
            Spacer()
            Button {
                vm.showTipSavedSection = false
            } label: {
                Label("Close", systemImage: "xmark")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.tertiarySystemBackground), in: Capsule())
            }
            
        }
        .padding(.bottom, 12)
        .tint(.yellow)
        .padding(.horizontal, dw(0.05))
    }
}
