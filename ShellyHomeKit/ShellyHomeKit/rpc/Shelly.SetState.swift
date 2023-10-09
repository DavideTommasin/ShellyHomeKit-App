//
//  Shelly.SetState.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

func ShellySetState(shellyInfoIn: ShellyInfo, index: Int, state: Bool, isToggle: Bool, button: Binding<Bool>){
    button.wrappedValue = true
    
    var parameters: [String: Any] = [:]
    let idS = String(shellyInfoIn.components[index].id)
    let type = String(shellyInfoIn.components[index].type)
    
    if (isToggle) {
        parameters =
        [
            "id": idS,
            "type": type,
            "state":
                [
                    "toggle": state
                ] as [String : Any]
        ]
    }
    else{
        parameters =
        [
            "id": idS,
            "type": type,
            "state":
                [
                    "state": state
                ] as [String : Any]
        ]
    }
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Shelly.SetState", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        button.wrappedValue = false
    }
}
