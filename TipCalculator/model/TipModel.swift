//
//  TipModel.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 2.10.2025.
//


//
//  TipModel.swift
//

import Foundation

struct TipModel: Identifiable, Codable {
    var id: UUID
    var title: String?
    var createdAt: Date
    var baseAmount: Double
    var percent: Int
    var tipAmount: Double
    var totalAmount: Double
    var peopleCount: Int
    var currency: String
}
