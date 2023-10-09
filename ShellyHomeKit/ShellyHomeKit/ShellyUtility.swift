//
//  ShellyUtility.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI
import CryptoKit
import WebKit

struct CustomText: UIViewRepresentable {
    var labelLeft: String
    var labelRight: String

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()

        let labelLX = UILabel()
        labelLX.text = labelLeft
        containerView.addSubview(labelLX)

        let labelRX = UILabel()
        labelRX.text = labelRight
        labelRX.setContentHuggingPriority(.defaultHigh, for: .vertical)
        labelRX.setContentHuggingPriority(.defaultLow, for: .horizontal)
        containerView.addSubview(labelRX)

        labelLX.translatesAutoresizingMaskIntoConstraints = false
        labelRX.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelLX.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            labelLX.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            labelRX.leadingAnchor.constraint(equalTo: labelLX.trailingAnchor, constant: 8),
            labelRX.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            labelRX.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let labelRX = uiView.subviews.compactMap({ $0 as? UILabel }).first {
            if labelRight.isEmpty {
                labelRX.text = "(empty)"
                labelRX.textColor = .gray
            }
            else{
                labelRX.text = labelRight
            }
            labelRX.text = labelRight
        }
        if let labelLX = uiView.subviews.compactMap({ $0 as? UILabel }).first {
            if labelLeft.isEmpty {
                labelLX.text = "(empty)"
                labelLX.textColor = .gray
            }
            else{
                labelLX.text = labelLeft
            }
        }
    }
}

func showAlert(titleMessage: String, errorMessage: String) {
    let alertController = UIAlertController(title: titleMessage, message: errorMessage, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    // Get the topmost visible view controller from a relevant window scene
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let topViewController = windowScene.windows.first?.rootViewController {
        topViewController.present(alertController, animated: true, completion: nil)
    }
}

func calculateSHA256Hash(inputString: String) -> String {
    let inputData = Data(inputString.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
    return hashString
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
