//
//  ShellyHomeKitDetail.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 16/06/23.
//

import SwiftUI
import Alamofire

struct ShellyDetailsHomeKit: View {
    @State var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
    @State private var password = ""
    
    var body: some View {
        if (shellyInfo.model == "Shelly1")//||
            //shellyInfo.model == "Shelly25")
        {
            Text(shellyInfo.name).font(.title)
            if shellyInfo.auth_en && shellyInfo.components.isEmpty {
                VStack {
                    Form {
                        HStack {
                            Text("Password:")
                                .padding(.vertical, 5)
                            TextField("", text: $password)
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                LogInShellyHomekit(shellyInfoIn: shellyInfo){ shellyOut in
                                    shellyInfo = shellyOut
                                }
                            }) {
                                Text("    Log In    ")
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
                }
                .onAppear(){
                    findNonce{ nonceValue in
                        shellyInfo.auth.nonce = nonceValue
                    }
                }
            }
            else{
                VStack {
                    List {
                        NavigationLink(destination: ShellyGeneralSettings(shellyInfo: $shellyInfo)){
                            Text("General Settings")
                        }
                        NavigationLink(destination: ShellyComponents(shellyInfo: $shellyInfo)){
                            Text("Components")
                        }
                        NavigationLink(destination: ShellyHomeKitSettings(shellyInfo: shellyInfo)){
                            Text("HomeKit Settings")
                        }
                        NavigationLink(destination: ShellyWiFiSettings(shellyInfo: $shellyInfo)){
                            Text("WiFi Settings")
                        }
                        NavigationLink(destination: ShellySecuritySettings(shellyInfo: shellyInfo)){
                            Text("Security Settings")
                        }
                        NavigationLink(destination: ShellySystem(shellyInfo: shellyInfo)){
                            Text("System")
                        }
                        NavigationLink(destination: ShellyFirmware(shellyInfo: shellyInfo)){
                            Text("Firmware")
                        }
                    }
                    NavigationLink(destination: WebView(urlString: shellyInfo.ipHost)) {
                        Text("Open Web Page")
                    }
                }
                .onAppear(){
                    ShellyGetInfoExt(shellyInfoIn: shellyInfo) { shellyOut in
                        shellyInfo = shellyOut
                    }
                }
            }
        }
        else
        {
            WebView(urlString: shellyInfo.ipHost)
        }
    }
    
    func LogInShellyHomekit(shellyInfoIn: ShellyInfo, completion: @escaping (ShellyInfo) -> Void) {
        isSavingBtn = true
        
        var shellyInfoOut: ShellyInfo = shellyInfoIn
        
        shellyInfoOut.auth.realm = shellyInfoOut.device_id
      //shellyInfoOut.auth.nonce already set
        shellyInfoOut.auth.username = "admin"
        shellyInfoOut.auth.cnonce = "\(Int(ceil(Double.random(in: 0..<1)*100000000)))"
        shellyInfoOut.auth.algorithm = "SHA-256"
        shellyInfoOut.auth.ha1 = calculateSHA256Hash(inputString: "admin:\(shellyInfo.device_id):\(password)")
        let ha2 = calculateSHA256Hash(inputString: "dummy_method:dummy_uri")
        shellyInfoOut.auth.response = calculateSHA256Hash(inputString: "\(shellyInfoOut.auth.ha1):\(shellyInfoOut.auth.nonce):1:\(shellyInfoOut.auth.cnonce):auth:\(ha2)")
        
        ShellyGetInfoExt(shellyInfoIn: shellyInfoOut) { shellyOut in
            shellyInfoOut = shellyOut
            completion(shellyInfoOut)
        }
        
        isSavingBtn = false
    }
    
    func findNonce(completion: @escaping (Int) -> Void) {
        let parameters: [String: Any] = [:]
        
        let urRequest = shellyInfo.ipHost
        AF.request(urRequest+"/rpc/Shelly.GetInfoExt", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil){$0.timeoutInterval = 3}
            .validate(statusCode: 200 ..< 299)
            .responseData { response in
                switch response.result {
                case .success(_):
                    completion(0)
                    return
                case .failure(_):
                    if let statusCode = response.response?.statusCode, statusCode == 401 {
                        if let headers = response.response?.allHeaderFields {
                            if let headerAuth = headers["Www-Authenticate"] as? String {
                                if let nonceRange = headerAuth.range(of: #"nonce="([^"]+)""#, options: .regularExpression) {
                                    let nonceValueHex = String(headerAuth[nonceRange].dropFirst(7).dropLast(1))
                                    let nonceValue = Int(nonceValueHex, radix: 16) ?? 0
                                    completion(nonceValue)
                                }
                            }
                        }
                        return
                    } else {
                        completion(0)
                        return
                    }
                }
            }
    }
}

