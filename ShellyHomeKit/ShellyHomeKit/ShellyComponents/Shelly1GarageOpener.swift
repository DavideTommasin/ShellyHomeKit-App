//
//  Shelly1GarageOpener.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

struct Shelly1GarageOpener: View {
    @Binding var shellyInfo: ShellyInfo
    var index: Int
    
    @State private var setStateBtn = false
    @State private var isSavingBtn = false
    @State private var isSavingBtnTgl = false
    
    @State private var selectedCloseSensor: String = ""
    @State private var closeSensor = ["Normally Closed","Normally Open"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: sectionHeader(shellyComponent: shellyInfo.components[index])) {
                    HStack {
                        Text("Name:")
                            .padding(.vertical, 5)
                        TextField("", text: $shellyInfo.components[index].name)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 5)
                            .onAppear {
                                if shellyInfo.components[index].name.isEmpty {
                                    shellyInfo.components[index].name = "(empty)"
                                }
                            }
                    }
                    
                    CustomText(labelLeft: "Status:", labelRight: String(shellyInfo.components[index].cur_state_str))
                        .padding(.vertical, 5)
                        .multilineTextAlignment(.leading)
                    
                    Picker("", selection: $selectedCloseSensor) {
                        ForEach(closeSensor, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: selectedCloseSensor) { newValue in
                        if newValue == "Normally Closed" {
                            shellyInfo.components[index].close_sensor_mode = 0
                        } else if newValue == "Normally Open" {
                            shellyInfo.components[index].close_sensor_mode = 1
                        }
                    }
                    .onAppear {
                        if shellyInfo.components[index].close_sensor_mode == 0 {
                            selectedCloseSensor = "Normally Closed"
                        } else if shellyInfo.components[index].close_sensor_mode == 1 {
                            selectedCloseSensor = "Normally Open"
                        }
                    }
                    
                    HStack {
                        Text("Movement Time:")
                            .padding(.vertical, 5)
                        TextField("", text: Binding<String>(
                            get: { String(shellyInfo.components[index].move_time) },
                            set: { shellyInfo.components[index].move_time = Int($0) ?? 0 }
                        ))
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 5)
                        Text("seconds")
                            .padding(.vertical, 5)
                    }
                    
                    HStack {
                        Text("Pulse Time:")
                            .padding(.vertical, 5)
                        TextField("", text: Binding<String>(
                            get: { String(shellyInfo.components[index].pulse_time_ms) },
                            set: { shellyInfo.components[index].pulse_time_ms = Int($0) ?? 0 }
                        ))
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 5)
                        Text("seconds")
                            .padding(.vertical, 5)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            ShellySetConfigComponents(shellyInfoIn: shellyInfo, index: index, button: $isSavingBtn)
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
                    HStack {
                        Spacer()
                        Button(action: {
                            ShellySetState(shellyInfoIn: shellyInfo, index: index, state: true, isToggle: true, button: $isSavingBtnTgl)
                        }) {
                            Text("    Toggle    ")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(30)
                        }
                        .opacity(isSavingBtnTgl ? 0.5 : 1.0)
                        .disabled(isSavingBtnTgl)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func sectionHeader(shellyComponent: Component) -> some View {
        HStack {
            Spacer()
            Text("\(shellyInfo.model) - \(shellyComponent.name)")
                .textCase(nil)
                .font(.title2)
            Spacer()
        }
    }
}
