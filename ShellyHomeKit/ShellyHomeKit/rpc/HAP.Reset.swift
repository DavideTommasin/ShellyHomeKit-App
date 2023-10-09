//
//  HAP.Reset.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

func HAPReset(shellyInfoIn: ShellyInfo, button: Binding<Bool>) {
    button.wrappedValue = true
    
    let parameters: [String: Any] =
    [
        "delay_ms": 500
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "HAP.Reset", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        showAlert(titleMessage: "System Reset", errorMessage: "System is resetting and will reconnect when ready")
        button.wrappedValue = false
    }
}
