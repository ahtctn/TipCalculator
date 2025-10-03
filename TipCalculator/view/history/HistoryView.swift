//
//  HistoryView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 3.10.2025.
//


import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var vm: HomeViewModel        // ⬅️ HomeVM’i bağladık
    @Environment(\.dismiss) private var dismiss
    @State private var search: String = ""

    var body: some View {
        ZStack {
            AnimatedBackgroundView().ignoresSafeArea()

            VStack(spacing: 12) {
                // Üst bar
                HStack {
                    Text("History")
                        .font(.title.bold())
                        .foregroundStyle(.white.opacity(0.95))
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                if filtered.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        Text(vm.history.isEmpty ? "No tips yet" : "No results")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(filtered) { m in
                            HistoryRow(model: m)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: vm.deleteHistory)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listStyle(.plain)
                    .refreshable { vm.loadHistory() }

                }
            }
        }
        .searchable(text: $search)
        .onAppear { vm.loadHistory() }
    }

    // MARK: - Filter
    private var filtered: [TipModel] {
        let q = search.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return vm.history }
        return vm.history.filter { m in
            let title = (m.title ?? "").lowercased()
            return title.contains(q)
            || "\(m.percent)%".contains(q)
            || displayMoney(m.baseAmount, m.currency).lowercased().contains(q)
            || displayMoney(m.totalAmount, m.currency).lowercased().contains(q)
        }
    }
}

