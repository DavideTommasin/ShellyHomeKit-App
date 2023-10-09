//
//  ShellyDetailShellyCloud.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 03/07/23.
//

import SwiftUI
import Alamofire

struct ShellyDetailShellyCloud: View {
    @State var shellyInfo: ShellyInfo
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isFlashing = false
    @State private var showAlertBool = false
    
    var body: some View {
        Text(shellyInfo.name).font(.title)
        
        VStack {
            if isFlashing {
                ProgressView("Flashing Shelly...Please wait")
            } else {
                HStack {
                    Spacer()
                    Button(action: {
                        flashShelly()
                    }) {
                        Text("Flash Shelly")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                    Spacer()
                }
            }
            Text("The operation will take about 1 minute")
                .font(.footnote)
                .opacity(0.4)
        }
        .alert(isPresented: $showAlertBool) {
            Alert(
                title: Text("Flashed"),
                message: Text("Shelly Flashed! All Right!"),
                dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
    
    func flashShelly() {
        isFlashing = true
        
        /*http://A.B.C.D/ota?url=http://shelly.rojer.cloud/update*/
        let urlRequest: String = shellyInfo.ipHost
        AF.request(urlRequest+"/ota?url=http://shelly.rojer.cloud/update", method: .get, headers: nil)
            .responseData { response in
                switch response.result {
                case .success(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                        isFlashing = false
                        showAlertBool = true
                    }
                case .failure(_):
                    showAlert(titleMessage: "Network Error", errorMessage: "Failed to flash shelly")
                    return
                }
            }
    }
}
