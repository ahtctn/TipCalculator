//
//  SupportEmail.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import SwiftUI
import UIKit

// SupportEmail Yapısı
struct SupportEmail {
    let toAdress: String
    let subject: String
    let messageHeader: String
    
    var body: String {
        """
        Application Name: \(Bundle.main.appName)
        iOS: \(UIDevice.current.systemVersion)
        DeviceModel: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
        \(messageHeader)
        -----------------------------------------------
        """
    }
    
    func send() {
        let urlString = "mailto:\(toAdress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        
        // URL'yi açma işlemi
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("This device does not support email sending.")
        }
    }
}

// UIDevice Extension for Model Name
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let identifier = withUnsafePointer(to: &systemInfo.machine) { (pointer) -> String in
            let data = Data(bytes: pointer, count: Int(_SYS_NAMELEN))
            return String(data: data, encoding: .utf8) ?? "Unknown"
        }
        return identifier
    }
}
