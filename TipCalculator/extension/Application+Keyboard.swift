//
//  Application+Keyboard.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 27.06.2025.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
