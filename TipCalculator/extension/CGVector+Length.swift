//
//  CGVector+Length.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.09.2025.
//

import Foundation
extension CGVector {
    var length: CGFloat { sqrt(dx*dx + dy*dy) }
}
