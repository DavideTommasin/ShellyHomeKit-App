//
//  ShellyGeneralSettings.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellyGeneralSettings: View {
    @Binding var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
    
    @State private var selectedMode: String = ""
    @State private var modes = ["Switch", "Garage Door Opener"]
    
    var body: some View {
        Text("General Settings").font(.title)
        
        VStack {
            Form {
                ForEach(shellyInfo.components.indices, id: \.self) { index in
                    HStack {
                        Text("Name:")
                            .padding(.vertical, 5)
                        TextField("", text: $shellyInfo.name)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 5)
                            .onAppear {
                                if shellyInfo.name.isEmpty {
                                    shellyInfo.name = "(empty)"
                                }
                            }
                    }
                    
                    Picker("", selection: $selectedMode) {
                        ForEach(modes, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: selectedMode) { newValue in
                        shellyInfo.components[index].type = newValue == "Switch" ? ShellyType.kSwitch.rawValue : 2
                    }
                    .onAppear {
                        selectedMode = shellyInfo.components[index].type == ShellyType.kSwitch.rawValue ? "Switch" : "Garage Door Opener"
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            ShellySetConfig(shellyInfoIn: shellyInfo, index: index, button: $isSavingBtn)
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
            }
        }
    }
}
