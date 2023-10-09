//
//  ShellyEntities.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 17/06/23.
//
import Foundation

struct Shelly: Identifiable
{
    let id = UUID()
    var typeCloud: Int
    var typeCloudName: String
    var shellyInfo: [ShellyInfo]
}

struct ShellyInfo: Identifiable {
    let id = UUID()
    var typeCloud: Int
    var typeCloudName: String
    var ipHost: String
    var auth: Authentication
    var device_id: String
    var name: String
    var app: String
    var model: String
    var stock_fw_model: String
    var host: String
    var version: String
    var fw_build: String
    var uptime: Int
    var failsafe_mode: Bool
    var auth_en: Bool
    var auth_domain: String
    var hap_cn: Int
    var hap_running: Bool
    var hap_paired: Bool
    var hap_ip_conns_pending: Int
    var hap_ip_conns_active: Int
    var hap_ip_conns_max: Int
    var sys_mode: Int
    var wc_avail: Bool
    var gdo_avail: Bool
    var debug_en: Bool
    var wifi_en: Bool
    var wifi_ssid: String
    var wifi_pass: String
    var wifi_pass_h: String
    var wifi_ip: String
    var wifi_netmask: String
    var wifi_gw: String
    var wifi1_en: Bool
    var wifi1_ssid: String
    var wifi1_pass: String
    var wifi1_ip: String
    var wifi1_netmask: String
    var wifi1_gw: String
    var wifi_ap_en: Bool
    var wifi_ap_ssid: String
    var wifi_ap_pass: String
    var wifi_connecting: Bool
    var wifi_connected: Bool
    var wifi_conn_ssid: String
    var wifi_conn_rssi: Int
    var wifi_conn_ip: String
    var wifi_status: String
    var wifi_sta_ps_mode: Int
    var mac_address: String
    var ota_progress: Int
    var ota_version: String
    var ota_build: String
    var components: [Component]
}

struct Authentication {
    var ha1: String
    var realm: String
    var nonce: Int
    var username: String
    var cnonce: String
    var algorithm: String
    var response: String
}

struct Component: Hashable {
    var id: Int
    var type: Int
    var name: String
    //Shelly 1 Switch
    var svc_type: Int
    var valve_type: Int
    var in_mode: Int
    var in_inverted: Bool
    var initial: Int
    var state: Bool
    var auto_off: Bool
    var auto_off_delay: Double
    var state_led_en: Int
    var out_inverted: Bool
    var hdim: Bool
    //Shelly 1 Garage Doar
    var cur_state: Int
    var cur_state_str: String
    var move_time: Int
    var pulse_time_ms: Int
    var close_sensor_mode: Int
    var open_sensor_mode: Int
    var out_mode: Int
}

enum ShellyType: Int {
    case kSwitch = 0
    case kOutlet = 1
    case kLock = 2
    case kStatelessSwitch = 3
    case kWindowCovering = 4
    case kGarageDoorOpener = 5
    case kDisabledInput = 6
    case kMotionSensor = 7
    case kOccupancySensor = 8
    case kContactSensor = 9
    case kDoorbell = 10
    case kLightBulb = 11
    case kTemperatureSensor = 12
    case kLeakSensor = 13
    case kSmokeSensor = 14
    case kCarbonMonoxideSensor = 15
    case kCarbonDioxideSensor = 16
    case kMax
}
