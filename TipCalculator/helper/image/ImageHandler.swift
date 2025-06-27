//
//  ImageHandler.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import SwiftUI

struct ImageHandler {
    
    static func makeImage(_ image: ImageHelper.images) -> Image {
        Image(image.rawValue)
            .resizable()
            .interpolation(.low)
            .antialiased(false)
    }
}
