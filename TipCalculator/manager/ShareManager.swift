//
//  ShareManager.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 30.06.2025.
//

import UIKit

final class ShareManager {
    static let shared = ShareManager()
    
    private init() {}
    
    func shareApp(from viewController: UIViewController) {
        // App Store URL'ni buraya yazdım:
        guard let appURL = URL(string: Constants.appLink) else {
            print("Invalid App Store URL.")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = viewController.view // iPad için

        viewController.present(activityVC, animated: true, completion: nil)
    }
}
