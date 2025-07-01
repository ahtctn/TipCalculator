//
//  MailManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI
import UIKit
import Combine

// Singleton Manager
final class MailManager: ObservableObject {
    static let shared = MailManager()  // Singleton instance
    
    private init() { }
    
    // SupportEmail yapısını mail göndermek için kullanma
    func sendSupportEmail(subject: String, messageHeader: String, toAdress: String) {
        let supportEmail = SupportEmail(
            toAdress: toAdress,
            subject: subject,
            messageHeader: messageHeader
        )
        supportEmail.send()
    }
}




