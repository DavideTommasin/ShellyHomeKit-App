//
//  ShellyList.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 15/06/23.
//

import SwiftUI
import Alamofire

struct ShellyList: View {
    @State private var allShelly: [Shelly] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        listAllShelly { shelly in
                            allShelly = shelly
                        }
                    }) {
                        Text("Refresh")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                Text("Shelly HomeKit").font(.title)
                List {
                    ForEach(allShelly) { shelly in
                        Section(header: Text(shelly.typeCloudName)) {
                            ForEach(shelly.shellyInfo.sorted(by: { $0.name < $1.name })){ s in
                                if s.typeCloud == 0 {
                                    NavigationLink(destination: ShellyDetailsHomeKit(shellyInfo: s)){
                                        Text(s.name)
                                    }
                                } else if s.typeCloud == 1 {
                                    NavigationLink(destination: ShellyDetailShellyCloud(shellyInfo: s)){
                                        Text(s.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Back", displayMode: .inline)
            .navigationBarHidden(true)
            .onAppear {
                listAllShelly { shelly in
                    allShelly = shelly
                }
            }
        }
    }
}

func listAllShelly(completion: @escaping ([Shelly]) -> Void) {
    var allShelly: [Shelly] = [
        Shelly(typeCloud: 0, typeCloudName: "Shelly HomeKit", shellyInfo: []),
        Shelly(typeCloud: 1, typeCloudName: "Shelly Cloud", shellyInfo: [])
    ]
    let parameters: [String: Any] = [:]
    
    for i in 1...255
    {
        let urRequest: String = "http://192.168.1."+String(i)
        AF.request(urRequest+"/rpc/Shelly.GetInfo", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil){$0.timeoutInterval = 3}
            .validate(statusCode: 200 ..< 299)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            completion(allShelly)
                            return
                        }
                        
                        allShelly[0].shellyInfo.append(
                            ShellyInfo(
                                typeCloud: 0,
                                typeCloudName:"Shelly HomeKit",
                                ipHost: urRequest,
                                auth: Authentication(
                                    ha1: "",
                                    realm: "",
                                    nonce: 0,
                                    username: "",
                                    cnonce: "",
                                    algorithm: "",
                                    response: ""
                                ),
                                device_id: jsonObject["device_id"] as! String,
                                name: jsonObject["name"] as! String,
                                app: jsonObject["app"] as! String,
                                model: jsonObject["model"] as! String,
                                stock_fw_model: jsonObject["stock_fw_model"] as! String,
                                host: jsonObject["host"] as! String,
                                version: jsonObject["version"] as! String,
                                fw_build: jsonObject["fw_build"] as! String,
                                uptime: jsonObject["uptime"] as! Int,
                                failsafe_mode: jsonObject["failsafe_mode"] as! Bool,
                                auth_en: jsonObject["auth_en"] as! Bool,
                                auth_domain: "",
                                hap_cn: -1,
                                hap_running: false,
                                hap_paired: false,
                                hap_ip_conns_pending: -1,
                                hap_ip_conns_active: -1,
                                hap_ip_conns_max: -1,
                                sys_mode: -1,
                                wc_avail: false,
                                gdo_avail: false,
                                debug_en: false,
                                wifi_en: false,
                                wifi_ssid: "",
                                wifi_pass: "",
                                wifi_pass_h: "",
                                wifi_ip: "",
                                wifi_netmask: "",
                                wifi_gw: "",
                                wifi1_en: false,
                                wifi1_ssid: "",
                                wifi1_pass: "",
                                wifi1_ip: "",
                                wifi1_netmask: "",
                                wifi1_gw: "",
                                wifi_ap_en: false,
                                wifi_ap_ssid: "",
                                wifi_ap_pass: "",
                                wifi_connecting: false,
                                wifi_connected: false,
                                wifi_conn_ssid: "",
                                wifi_conn_rssi: -1,
                                wifi_conn_ip: "",
                                wifi_status: "",
                                wifi_sta_ps_mode: -1,
                                mac_address: "",
                                ota_progress: -1,
                                ota_version: "",
                                ota_build: "",
                                components: []
                            )
                        )
                        completion(allShelly)
                    } catch {
                        completion(allShelly)
                    }
                case .failure(_):
                    if let statusCode = response.response?.statusCode, statusCode == 404 {
                        AF.request(urRequest+"/settings", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil) {$0.timeoutInterval = 2}
                            .validate(statusCode: 200 ..< 299)
                            .responseData { response404 in
                                switch response404.result {
                                case .success(let data):
                                    do {
                                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                            completion(allShelly)
                                            return
                                        }
                                        let device = jsonObject["device"] as! [String: Any]
                                        let hostname = device["hostname"] as! String
                                        let shellyName = jsonObject["name"] as? String ?? hostname
                                        
                                        allShelly[1].shellyInfo.append(
                                            ShellyInfo(
                                                typeCloud: 1,
                                                typeCloudName:"Shelly Cloud",
                                                ipHost: urRequest,
                                                auth: Authentication(
                                                    ha1: "",
                                                    realm: "",
                                                    nonce: 0,
                                                    username: "",
                                                    cnonce: "",
                                                    algorithm: "",
                                                    response: ""
                                                ),
                                                device_id: "",
                                                name: shellyName,
                                                app: "",
                                                model: "",
                                                stock_fw_model: "",
                                                host: "",
                                                version: "",
                                                fw_build: "",
                                                uptime: -1,
                                                failsafe_mode: false,
                                                auth_en: false,
                                                auth_domain: "",
                                                hap_cn: -1,
                                                hap_running: false,
                                                hap_paired: false,
                                                hap_ip_conns_pending: -1,
                                                hap_ip_conns_active: -1,
                                                hap_ip_conns_max: -1,
                                                sys_mode: -1,
                                                wc_avail: false,
                                                gdo_avail: false,
                                                debug_en: false,
                                                wifi_en: false,
                                                wifi_ssid: "",
                                                wifi_pass: "",
                                                wifi_pass_h: "",
                                                wifi_ip: "",
                                                wifi_netmask: "",
                                                wifi_gw: "",
                                                wifi1_en: false,
                                                wifi1_ssid: "",
                                                wifi1_pass: "",
                                                wifi1_ip: "",
                                                wifi1_netmask: "",
                                                wifi1_gw: "",
                                                wifi_ap_en: false,
                                                wifi_ap_ssid: "",
                                                wifi_ap_pass: "",
                                                wifi_connecting: false,
                                                wifi_connected: false,
                                                wifi_conn_ssid: "",
                                                wifi_conn_rssi: -1,
                                                wifi_conn_ip: "",
                                                wifi_status: "",
                                                wifi_sta_ps_mode: -1,
                                                mac_address: "",
                                                ota_progress: -1,
                                                ota_version: "",
                                                ota_build: "",
                                                components: []
                                            )
                                        )
                                        completion(allShelly)
                                    } catch {
                                        completion(allShelly)
                                    }
                                case .failure(_):
                                    completion(allShelly)
                                }
                            }
                    } else {
                        completion(allShelly)
                    }
                }
            }
    }
}

