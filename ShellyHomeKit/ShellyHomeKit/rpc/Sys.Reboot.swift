//
//  Sys.Reboot.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

func SysReboot(shellyInfoIn: ShellyInfo, button: Binding<Bool>) {
    button.wrappedValue = true
    
    let parameters: [String: Any] =
    [
        "delay_ms": 500
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Sys.Reboot", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        showAlert(titleMessage: "System Reboot", errorMessage: "System is rebooting and will reconnect when ready")
        button.wrappedValue = false
    }
}
