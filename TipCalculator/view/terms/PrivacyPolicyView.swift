//
//  PrivacyPolicyView.swift
//  TipCalculator
//
//  Created by Ahmet Ali ÇETİN on 29.06.2025.
//


import SwiftUI

struct PrivacyPolicyView: View {
    let markdown = """
    "\n\
    **Privacy Policy**\n\
    \n\
    This privacy policy applies to the Breathe Better: Calm Your Mind app (hereby referred to as \"Application\") for mobile devices...\n\
    \n\
    By using this app, you also agree to Apple’s Privacy Policy, which can be found at:\n\
    https://www.apple.com/legal/privacy/\n\
    \n\
    **Information Collection and Use**\n\
    \n\
    The Application collects information when you download and use it. This information may include:\n\
    \n\
    • Your device's IP address  \n\
    • The pages of the app you visit  \n\
    • The operating system...  \n\
    ...\n\
    \n\
    **Third-Party Services**\n\
    \n\
    • [RevenueCat](https://www.revenuecat.com/privacy)\n\
    \n\
    ...\n\
    \n\
    **Contact**\n\
    \n\
    newroadsoftware@gmail.com\n\
    \n\
    _Effective as of 2025-06-11_"
"""
    var body: some View {
        ScrollView {
            Text(markdownText)
                .padding()
        }
        .navigationTitle("Gizlilik")
    }

    var markdownText: String {
        markdown
    }
}
