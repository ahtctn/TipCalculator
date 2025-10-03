//
//  HistoryRow.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//

import SwiftUI

struct HistoryRow: View {
    let model: TipModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Başlık + Tarih
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(rowTitle(model))
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .imageScale(.small)
                    Text(dateStr(model.createdAt))
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.65))
            }

            // Alt satır: küçük özet + büyük total
            HStack(spacing: 10) {
                // Küçük & soluk bilgiler
                HStack(spacing: 8) {
                    Text(displayMoney(model.baseAmount, model.currency))
                    miniDivider
                    Text("%\(model.percent)")
                    miniDivider
                    Text("+ \(displayMoney(model.tipAmount, model.currency)) tip")
                }
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.75))

                Spacer()

                // Büyük & kalın total
                Text(displayMoney(model.totalAmount, model.currency))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.green)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .frame(width: dw(0.9))
    }

    private var miniDivider: some View {
        Divider()
            .frame(height: 12)
            .background(Color.white.opacity(0.12))
    }

    private func rowTitle(_ m: TipModel) -> String {
        if let t = m.title, !t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return t
        }
        return "Tip \(m.percent)% • \(displayMoney(m.totalAmount, m.currency))"
    }
}

// Helpers (aynı)
func displayMoney(_ value: Double, _ currency: String) -> String {
    let intPart = floor(value)
    if abs(value - intPart) < 0.005 {
        return "\(Int(intPart)) \(currency)"     // .00 ise kırp
    } else {
        return String(format: "%.2f %@", value, currency)
    }
}

func dateStr(_ d: Date) -> String {
    let f = DateFormatter()
    f.dateStyle = .medium
    f.timeStyle = .short
    return f.string(from: d)
}
