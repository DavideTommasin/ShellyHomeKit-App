//
//  ShellyWiFiSettings.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellyWiFiSettings: View {
    @Binding var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
        
    @State private var selectedOptionWiFi = 0
    private let optionsWiFi = ["WiFi 1", "WiFi 2", "AP"]
    @State private var showWiFi1 = true
    @State private var showWiFi2 = false
    @State private var showAp = false
    
    @State private var staticIp1:Bool = false
    
    @State private var staticIp2:Bool = false
    
    @State private var selectedPowerSaving: String = ""
    @State private var powerSaving = ["Disabled", "1", "2"]
    
    var body: some View {
        Text("WiFi Settings").font(.title)
        
        VStack {
            Form {
                Section(){
                    Picker("", selection: $selectedOptionWiFi) {
                        ForEach(optionsWiFi.indices, id: \.self) { index in
                            Text(optionsWiFi[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    if showWiFi1 {
                        Toggle("Enable: ", isOn: $shellyInfo.wifi_en)
                            .padding(.vertical, 2)
                        HStack {
                            Text("Network:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi_ssid)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi_ssid.isEmpty {
                                        shellyInfo.wifi_ssid = "(empty)"
                                    }
                                }
                        }
                        HStack {
                            Text("Password:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi_pass)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi_pass.isEmpty {
                                        shellyInfo.wifi_pass = "(empty)"
                                    }
                                }
                        }
                        Toggle("Static Ip: ", isOn: $staticIp1)
                            .padding(.vertical, 2)
                            .onAppear(){
                                staticIp1 = shellyInfo.wifi_ip != "" ? true : false
                            }
                    }
                    if showWiFi2 {
                        Toggle("Enable: ", isOn: $shellyInfo.wifi1_en)
                            .padding(.vertical, 2)
                        HStack {
                            Text("Network:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi1_ssid)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi1_ssid.isEmpty {
                                        shellyInfo.wifi1_ssid = "(empty)"
                                    }
                                }
                        }
                        HStack {
                            Text("Password:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi1_pass)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi1_pass.isEmpty {
                                        shellyInfo.wifi1_pass = "(empty)"
                                    }
                                }
                        }
                        Toggle("Static Ip: ", isOn: $staticIp2)
                            .onAppear(){
                                staticIp2 = shellyInfo.wifi1_ip != "" ? true : false
                            }
                    }
                    if showAp {
                        Toggle("Enable: ", isOn: $shellyInfo.wifi_ap_en)
                            .padding(.vertical, 2)
                        HStack {
                            Text("Network:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi_ap_ssid)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi_ap_ssid.isEmpty {
                                        shellyInfo.wifi_ap_ssid = "(empty)"
                                    }
                                }
                        }
                        HStack {
                            Text("Password:")
                                .padding(.vertical, 5)
                            TextField("", text: $shellyInfo.wifi_ap_pass)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if shellyInfo.wifi_ap_pass.isEmpty {
                                        shellyInfo.wifi_ap_pass = "(empty)"
                                    }
                                }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            ShellySetWifiConfig(shellyInfoIn: shellyInfo, button: $isSavingBtn)
                        }) {
                            Text("    Save    ")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(30)
                        }
                        .opacity(isSavingBtn ? 0.5 : 1.0)
                        .disabled(isSavingBtn)
                        Spacer()
                    }
                }
                Section(){
                    Picker("Power Saving", selection: $selectedPowerSaving) {
                        ForEach(powerSaving, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onAppear {
                        if shellyInfo.wifi_sta_ps_mode == 1 {
                            selectedPowerSaving = "1"
                        }
                        else if shellyInfo.wifi_sta_ps_mode == 2 {
                            selectedPowerSaving = "2"
                        }
                        else {
                            selectedPowerSaving = "Disabled"
                        }
                    }
                    CustomText(labelLeft: "Status:", labelRight: String(shellyInfo.wifi_status))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    CustomText(labelLeft: "Network:", labelRight: String(shellyInfo.wifi_conn_ssid))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    CustomText(labelLeft: "IP:", labelRight: String(shellyInfo.wifi_conn_ip))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    CustomText(labelLeft: "RSSI:", labelRight: String(shellyInfo.wifi_conn_rssi))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    CustomText(labelLeft: "MAC:", labelRight: String(shellyInfo.mac_address))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .onChange(of: selectedOptionWiFi) { _ in
            if selectedOptionWiFi == 0 {
                showWiFi1 = true
                showWiFi2 = false
                showAp = false
            }
            else if selectedOptionWiFi == 1 {
                showWiFi1 = false
                showWiFi2 = true
                showAp = false
            }
            else if selectedOptionWiFi == 2 {
                showWiFi1 = false
                showWiFi2 = false
                showAp = true
            }
        }
    }
}
