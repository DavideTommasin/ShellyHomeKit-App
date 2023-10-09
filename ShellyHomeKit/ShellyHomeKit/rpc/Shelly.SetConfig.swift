//
//  Shelly.SetConfig.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

func ShellySetConfig(shellyInfoIn: ShellyInfo, index: Int, button: Binding<Bool>){
    button.wrappedValue = true
    
    let parameters: [String: Any] =
    [
        "config":
            [
                "name":shellyInfoIn.name,
                "sys_mode":shellyInfoIn.components[index].type
            ] as [String : Any]
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Shelly.SetConfig", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        button.wrappedValue = false
    }
}

func ShellySetConfigComponents(shellyInfoIn: ShellyInfo, index: Int, button: Binding<Bool>) {
    button.wrappedValue = true
    
    var parameters: [String: Any] = [:]
    
    if shellyInfoIn.components[index].type == ShellyType.kSwitch.rawValue {
        parameters =
        [
            "id": shellyInfoIn.components[index].id,
            "type": shellyInfoIn.components[index].type,
            "config":
                [
                    "name": shellyInfoIn.components[index].name,
                    "svc_type": shellyInfoIn.components[index].svc_type,
                    "initial_state": shellyInfoIn.components[index].initial,
                    "auto_off": shellyInfoIn.components[index].auto_off,
                    "auto_off_delay": shellyInfoIn.components[index].auto_off_delay,
                    "in_inverted": shellyInfoIn.components[index].in_inverted,
                    "out_inverted": shellyInfoIn.components[index].out_inverted,
                    "in_mode": shellyInfoIn.components[index].in_mode,
                    "valve_type": shellyInfoIn.components[index].valve_type,
                ] as [String : Any]
        ]
    }
    else if (shellyInfoIn.components[index].type == ShellyType.kGarageDoorOpener.rawValue){
        parameters =
        [
            "id": shellyInfoIn.components[index].id,
            "type": shellyInfoIn.components[index].type,
            "config":
                [
                    "name": shellyInfoIn.components[index].name,
                    "move_time": shellyInfoIn.components[index].move_time,
                    "pulse_time_ms": shellyInfoIn.components[index].pulse_time_ms,
                    "close_sensor_mode": shellyInfoIn.components[index].close_sensor_mode,
                ] as [String : Any]
        ]
    }
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Shelly.SetConfig", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        button.wrappedValue = false
    }
}
