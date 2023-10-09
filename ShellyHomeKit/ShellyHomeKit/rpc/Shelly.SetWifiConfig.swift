//
//  Shelly.SetWifiConfig.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

func ShellySetWifiConfig(shellyInfoIn: ShellyInfo, button: Binding<Bool>) {
    button.wrappedValue = true
    
    var sta: [String: Any] = [:]
    var sta1: [String: Any] = [:]
    var ap: [String: Any] = [:]
    
    if(shellyInfoIn.wifi_pass.allSatisfy({ $0 == "*" }) || shellyInfoIn.wifi_pass == "(empty)"){
        sta =
        [
            "enable": shellyInfoIn.wifi_en,
            "ssid": shellyInfoIn.wifi_ssid,
            "ip": shellyInfoIn.wifi_ip,
            "netmask": shellyInfoIn.wifi_netmask,
            "gw": shellyInfoIn.wifi_gw
        ] as [String : Any]
    }
    else{
        sta =
        [
            "enable": shellyInfoIn.wifi_en,
            "ssid": shellyInfoIn.wifi_ssid,
            "ip": shellyInfoIn.wifi_ip,
            "netmask": shellyInfoIn.wifi_netmask,
            "gw": shellyInfoIn.wifi_gw,
            "pass": shellyInfoIn.wifi_pass
        ] as [String : Any]
    }
    
    if(shellyInfoIn.wifi1_pass.allSatisfy({ $0 == "*" }) || shellyInfoIn.wifi1_pass == "(empty)"){
        sta1 =
        [
            "enable": shellyInfoIn.wifi1_en,
            "ssid": shellyInfoIn.wifi1_ssid,
            "ip": shellyInfoIn.wifi1_ip,
            "netmask": shellyInfoIn.wifi1_netmask,
            "gw": shellyInfoIn.wifi1_gw
        ] as [String : Any]
    }
    else{
        sta1 =
        [
            "enable": shellyInfoIn.wifi1_en,
            "ssid": shellyInfoIn.wifi1_ssid,
            "ip": shellyInfoIn.wifi1_ip,
            "netmask": shellyInfoIn.wifi1_netmask,
            "gw": shellyInfoIn.wifi1_gw,
            "pass": shellyInfoIn.wifi1_pass
        ] as [String : Any]
    }
    
    if(shellyInfoIn.wifi_ap_pass.allSatisfy({ $0 == "*" }) || shellyInfoIn.wifi_ap_pass == "(empty)"){
        ap =
        [
            "enable": shellyInfoIn.wifi_ap_en,
            "ssid": shellyInfoIn.wifi_ap_ssid,
        ] as [String : Any]
    }
    else{
        ap =
        [
            "enable": shellyInfoIn.wifi_ap_en,
            "ssid": shellyInfoIn.wifi_ap_ssid,
            "pass": shellyInfoIn.wifi_ap_pass
        ] as [String : Any]
    }
    let parameters: [String: Any] =
    [
        "sta": sta,
        "sta1": sta1,
        "ap": ap,
        "sta_ps_mode": shellyInfoIn.wifi_sta_ps_mode
    ]
    
    rpcCall(ipHost: shellyInfoIn.ipHost, method: "Shelly.SetWifiConfig", params: parameters, auth: shellyInfoIn.auth) { jsonObjectRoot in
        button.wrappedValue = false
    }
}
