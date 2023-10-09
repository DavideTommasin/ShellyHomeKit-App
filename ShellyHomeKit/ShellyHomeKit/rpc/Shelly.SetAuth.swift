//
//  Shelly.SetAuth.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 10/07/23.
//

import SwiftUI

func ShellySetAuth(shellyInfoIn: ShellyInfo, newHa1: String, button: Binding<Bool>){
    button.wrappedValue = true
    
    let parameters: [String: Any] =
    [
        "user": "admin",
        "realm": shellyInfoIn.device_id,
        "ha1": newHa1
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Shelly.SetAuth", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        button.wrappedValue = false
    }
}
