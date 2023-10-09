//
//  HAP.Setup.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI
import CommonCrypto

func HAPSetup(shellyInfoIn: ShellyInfo, codeHomekit: Binding<String>, idHomeKit: Binding<String>, urlQrCode: Binding<String>, button: Binding<Bool>) {
    button.wrappedValue = true
    
    (codeHomekit.wrappedValue, idHomeKit.wrappedValue) = generateCodeAndID(deviceID: shellyInfoIn.device_id, wifiSSID: shellyInfoIn.wifi_ssid, wifiPass: shellyInfoIn.wifi_pass)
    
    let parameters: [String: Any] =
    [
        "code": codeHomekit.wrappedValue,
        "id": idHomeKit.wrappedValue
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "HAP.Setup", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        if !jsonObjectRoot.isEmpty{
            let jsonObject = jsonObjectRoot["result"] as! [String: Any]
            codeHomekit.wrappedValue = jsonObject["code"] as! String
            idHomeKit.wrappedValue = jsonObject["id"] as! String
            urlQrCode.wrappedValue = jsonObject["url"] as! String
        }
        button.wrappedValue = false
    }
}

func generateCodeAndID(deviceID: String, wifiSSID: String?, wifiPass: String?) -> (code: String, id: String) {
    func sha256(_ input: String) -> String {
        guard let inputData = input.data(using: .utf8) else {
            return ""
        }
        
        var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = hashData.withUnsafeMutableBytes { hashBytes in
            inputData.withUnsafeBytes { inputBytes in
                CC_SHA256(inputBytes.baseAddress, CC_LONG(inputData.count), hashBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        
        let sha256Hex = hashData.map { String(format: "%02x", $0) }.joined()
        return sha256Hex
    }
    
    let input = deviceID + (wifiSSID ?? "") + (wifiPass ?? "")
    let seed = sha256(input).lowercased()
    var code = ""
    var id = ""
    for i in 0..<8 {
        let charIndex = seed.index(seed.startIndex, offsetBy: i)
        let charCode = seed.unicodeScalars[charIndex].value % 10
        code += "\(charCode)"
        if i == 2 || i == 4 {
            code += "-"
        }
    }
    for i in 0..<4 {
        let siIndex = seed.index(seed.startIndex, offsetBy: 10 + i)
        let si1 = seed.unicodeScalars[siIndex].value
        let si2Index = seed.index(seed.startIndex, offsetBy: 20 + i)
        let si2 = seed.unicodeScalars[si2Index].value
        let si = (si1 + si2) % 36
        let charIndex = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".index("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".startIndex, offsetBy: Int(si))
        let char = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[charIndex]
        id += "\(char)"
    }
    
    return (code, id)
}
