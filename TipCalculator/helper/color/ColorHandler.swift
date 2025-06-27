//
//  ColorHandler.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//


import SwiftUI

struct ColorHandler {
    
    static func makeColor( _ color: ColorHelper.mainColor) -> Color {
        return Color(color.rawValue)
    }
    
}
