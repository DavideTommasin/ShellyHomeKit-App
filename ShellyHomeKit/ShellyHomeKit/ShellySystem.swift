//
//  ShellySystem.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellySystem: View {
    @State var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
    @State private var showAlertReboot = false
    @State private var showAlertReset = false
    @State private var shouldNavigateToMainView = false
    
    var body: some View {
        Text("System").font(.title)
        
        VStack {
            Form {
                CustomText(labelLeft: "Model:", labelRight: String(shellyInfo.model))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                CustomText(labelLeft: "Device ID:", labelRight: String(shellyInfo.device_id))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                CustomText(labelLeft: "Host:", labelRight: String(shellyInfo.host))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                HStack {
                    Spacer()
                    Button(action: {
                        showAlertReboot = true
                    }) {
                        Text("    Reboot    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .opacity(isSavingBtn ? 0.5 : 1.0)
                            .disabled(isSavingBtn)
                    }
                    .alert(isPresented: $showAlertReboot) {
                        Alert(
                            title: Text("Confirm Reboot"),
                            message: Text("Are you sure you want to reboot the device?"),
                            primaryButton: .default(Text("Yes"), action: {
                                SysReboot(shellyInfoIn: shellyInfo, button: $isSavingBtn)
                                shouldNavigateToMainView = true
                            }),
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        showAlertReset = true
                    }) {
                        Text("    Reset    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .opacity(isSavingBtn ? 0.5 : 1.0)
                            .disabled(isSavingBtn)
                    }
                    .alert(isPresented: $showAlertReset) {
                        Alert(
                            title: Text("Confirm Reset"),
                            message: Text("This will erase all pairings and clear setup code. " +
                                          "Are you sure?"),
                            primaryButton: .default(Text("Yes"), action: {
                                HAPReset(shellyInfoIn: shellyInfo, button: $isSavingBtn)
                                shouldNavigateToMainView = true
                            }),
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                    Spacer()
                }
            }
        }
        .background(
            NavigationLink(destination: ShellyList().navigationBarBackButtonHidden(true), isActive: $shouldNavigateToMainView) {
                EmptyView()
            }
        )
    }
}
