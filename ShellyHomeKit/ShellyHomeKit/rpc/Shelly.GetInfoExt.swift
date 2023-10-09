//
//  Shelly.GetInfoExt.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

func ShellyGetInfoExt(shellyInfoIn: ShellyInfo, completion: @escaping (ShellyInfo) -> Void){
    var shellyInfoOut: ShellyInfo = shellyInfoIn
    
    let parameters: [String: Any] = [:]
    
    rpcCall(ipHost: shellyInfoOut.ipHost, method: "Shelly.GetInfoExt", params: parameters, auth: shellyInfoOut.auth) { jsonObjectRoot in
        if !jsonObjectRoot.isEmpty{
            let jsonObject = jsonObjectRoot["result"] as! [String: Any]
            
            var ComponentsS:[Component] = []
            if let componentsArray = jsonObject["components"] as? [[String: Any]] {
                for componentObject in componentsArray {
                    if let id: Int? = componentObject["id"] as? Int?,
                       let type: Int? = componentObject["type"] as? Int?,
                       let name: String? = componentObject["name"] as? String?,
                       let serviceType: Int? = componentObject["svc_type"] as? Int?,
                       let valveType: Int? = componentObject["valve_type"] as? Int?,
                       let inputMode: Int? = componentObject["in_mode"] as? Int?,
                       let inputInverted: Bool? = componentObject["in_inverted"] as? Bool?,
                       let initial: Int? = componentObject["initial"] as? Int?,
                       let state: Bool? = componentObject["state"] as? Bool?,
                       let autoOff = componentObject["auto_off"] as? Bool?,
                       let autoOffDelay: Double? = componentObject["auto_off_delay"] as? Double?,
                       let stateLEDEnabled: Int? = componentObject["state_led_en"] as? Int?,
                       let outputInverted: Bool? = componentObject["out_inverted"] as? Bool?,
                       let hDim: Bool? = componentObject["hdim"] as? Bool?,
                       let cur_state: Int? = componentObject["cur_state"] as? Int?,
                       let cur_state_str: String? = componentObject["cur_state_str"] as? String?,
                       let move_time: Int? = componentObject["move_time"] as? Int?,
                       let pulse_time_ms: Int? = componentObject["pulse_time_ms"] as? Int?,
                       let close_sensor_mode: Int? = componentObject["close_sensor_mode"] as? Int?,
                       let open_sensor_mode: Int? = componentObject["open_sensor_mode"] as? Int?,
                       let out_mode: Int? = componentObject["out_mode"] as? Int?
                    {
                        
                        let component = Component(id: id ?? -1,
                                                  type: type ?? -1,
                                                  name: name ?? "",
                                                  svc_type: serviceType ?? -1,
                                                  valve_type: valveType ?? 0,
                                                  in_mode: inputMode ?? -1,
                                                  in_inverted: inputInverted ?? false,
                                                  initial: initial ?? -1,
                                                  state: state ?? false,
                                                  auto_off: autoOff ?? false,
                                                  auto_off_delay: autoOffDelay ?? 0.000,
                                                  state_led_en: stateLEDEnabled ?? -1,
                                                  out_inverted: outputInverted ?? false,
                                                  hdim: hDim ?? false,
                                                  cur_state: cur_state ?? -1,
                                                  cur_state_str: cur_state_str ?? "",
                                                  move_time: move_time ?? -1,
                                                  pulse_time_ms: pulse_time_ms ?? -1,
                                                  close_sensor_mode: close_sensor_mode ?? -1,
                                                  open_sensor_mode: open_sensor_mode ?? -1,
                                                  out_mode: out_mode ?? -1)
                        ComponentsS.append(component)
                    }
                }
            }
            shellyInfoOut = ShellyInfo(
                typeCloud: shellyInfoIn.typeCloud,
                typeCloudName: shellyInfoIn.typeCloudName,
                ipHost: shellyInfoIn.ipHost,
                auth: shellyInfoIn.auth,
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
                auth_domain: jsonObject["auth_domain"] as? String ?? "",
                hap_cn: jsonObject["hap_cn"] as! Int,
                hap_running: jsonObject["hap_running"] as! Bool,
                hap_paired: jsonObject["hap_paired"] as! Bool,
                hap_ip_conns_pending: jsonObject["hap_ip_conns_pending"] as! Int,
                hap_ip_conns_active: jsonObject["hap_ip_conns_active"] as! Int,
                hap_ip_conns_max: jsonObject["hap_ip_conns_max"] as! Int,
                sys_mode: jsonObject["sys_mode"] as! Int,
                wc_avail: jsonObject["wc_avail"] as! Bool,
                gdo_avail: jsonObject["gdo_avail"] as! Bool,
                debug_en: jsonObject["debug_en"] as! Bool,
                wifi_en: jsonObject["wifi_en"] as! Bool,
                wifi_ssid: jsonObject["wifi_ssid"] as! String,
                wifi_pass: jsonObject["wifi_pass"] as! String,
                wifi_pass_h: jsonObject["wifi_pass_h"] as! String,
                wifi_ip: jsonObject["wifi_ip"] as! String,
                wifi_netmask: jsonObject["wifi_netmask"] as! String,
                wifi_gw: jsonObject["wifi_gw"] as! String,
                wifi1_en: jsonObject["wifi1_en"] as! Bool,
                wifi1_ssid: jsonObject["wifi1_ssid"] as! String,
                wifi1_pass: jsonObject["wifi1_pass"] as! String,
                wifi1_ip: jsonObject["wifi1_ip"] as! String,
                wifi1_netmask: jsonObject["wifi1_netmask"] as! String,
                wifi1_gw: jsonObject["wifi1_gw"] as! String,
                wifi_ap_en: jsonObject["wifi_ap_en"] as! Bool,
                wifi_ap_ssid: jsonObject["wifi_ap_ssid"] as! String,
                wifi_ap_pass: jsonObject["wifi_ap_pass"] as! String,
                wifi_connecting: jsonObject["wifi_connecting"] as! Bool,
                wifi_connected: jsonObject["wifi_connected"] as! Bool,
                wifi_conn_ssid: jsonObject["wifi_conn_ssid"] as! String,
                wifi_conn_rssi: jsonObject["wifi_conn_rssi"] as! Int,
                wifi_conn_ip: jsonObject["wifi_conn_ip"] as! String,
                wifi_status: jsonObject["wifi_status"] as! String,
                wifi_sta_ps_mode: jsonObject["wifi_sta_ps_mode"] as! Int,
                mac_address: jsonObject["mac_address"] as! String,
                ota_progress: jsonObject["ota_progress"] as! Int,
                ota_version: jsonObject["ota_version"] as! String,
                ota_build: jsonObject["ota_build"] as! String,
                components: ComponentsS
            )
            completion(shellyInfoOut)
        }
    }
}
