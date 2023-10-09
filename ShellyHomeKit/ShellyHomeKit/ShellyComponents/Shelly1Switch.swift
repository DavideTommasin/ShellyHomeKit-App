//
//  Shelly1Switch.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import SwiftUI

struct Shelly1Switch: View {
    @Binding var shellyInfo: ShellyInfo
    var index: Int
    
    @State private var setStateBtn = false
    @State private var isSavingBtn = false
    @State private var isSavingBtnTgl = false
    
    @State private var status = false
    
    @State private var selectedHAPServiceType: String = ""
    @State private var HAPServiceType = ["Disbled","Switch","Outlet","Lock","Valve"]
    
    @State private var selectedInputMode: String = ""
    @State private var inputMode = ["Momentary","Toggle","Edge","Detached","Activation"]
    
    @State private var invertedInput = false
    
    @State private var selectedInitialState: String = ""
    @State private var initialState = ["Off","On","Last","Input"]
    
    @State private var invertedOutput = false
    
    @State private var autoOff = false
    
    @State private var selectedCloseSensor: String = ""
    @State private var closeSensor = ["Normally Closed","Normally Open"]
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: sectionHeader(shellyComponent: shellyInfo.components[index])) {
                    Toggle("Status: ", isOn: $shellyInfo.components[index].state)
                        .padding(.vertical, 2)
                        .onChange(of: shellyInfo.components[index].state) { newValue in
                            ShellySetState(shellyInfoIn: shellyInfo, index: index, state: newValue, isToggle: false, button: $setStateBtn)
                        }
                    
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
                    
                    Picker("", selection: $selectedHAPServiceType) {
                        ForEach(HAPServiceType, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: selectedHAPServiceType) { newValue in
                        if(newValue == "Disbled"){
                            shellyInfo.components[index].svc_type = -1
                        }
                        else if(newValue == "Switch"){
                            shellyInfo.components[index].svc_type = 0
                        }
                        else if(newValue == "Outlet"){
                            shellyInfo.components[index].svc_type = 1
                        }
                        else if(newValue == "Lock"){
                            shellyInfo.components[index].svc_type = 2
                        }
                        else if(newValue == "Valve"){
                            shellyInfo.components[index].svc_type = 3
                        }
                    }
                    .onAppear {
                        if(shellyInfo.components[index].svc_type == -1){
                            selectedHAPServiceType = "Disbled"
                        }
                        else if(shellyInfo.components[index].svc_type == 0){
                            selectedHAPServiceType = "Switch"
                        }
                        else if(shellyInfo.components[index].svc_type == 1){
                            selectedHAPServiceType = "Outlet"
                        }
                        else if(shellyInfo.components[index].svc_type == 2){
                            selectedHAPServiceType = "Lock"
                        }
                        else if(shellyInfo.components[index].svc_type == 3){
                            selectedHAPServiceType = "Valve"
                        }
                    }
                    Picker("", selection: $selectedInputMode) {
                        ForEach(inputMode, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: selectedInputMode) { newValue in
                        if(newValue == "Momentary"){
                            shellyInfo.components[index].in_mode = 0
                        }
                        else if(newValue == "Toggle"){
                            shellyInfo.components[index].in_mode = 1
                        }
                        else if(newValue == "Edge"){
                            shellyInfo.components[index].in_mode = 2
                        }
                        else if(newValue == "Detached"){
                            shellyInfo.components[index].in_mode = 3
                        }
                        else if(newValue == "Activation"){
                            shellyInfo.components[index].in_mode = 4
                        }
                    }
                    .onAppear {
                        if(shellyInfo.components[index].in_mode == 0){
                            selectedInputMode = "Momentary"
                        }
                        else if(shellyInfo.components[index].in_mode == 1){
                            selectedInputMode = "Toggle"
                        }
                        else if(shellyInfo.components[index].in_mode == 2){
                            selectedInputMode = "Edge"
                        }
                        else if(shellyInfo.components[index].in_mode == 3){
                            selectedInputMode = "Detached"
                        }
                        else if(shellyInfo.components[index].in_mode == 4){
                            selectedInputMode = "Activation"
                        }
                    }
                    Toggle("Inverted Input: ", isOn: $shellyInfo.components[index].in_inverted)
                        .padding(.vertical, 2)
                    Picker("", selection: $selectedInitialState) {
                        ForEach(initialState, id: \.self) { item in
                            Text(item).tag(item)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 5)
                    .onChange(of: selectedInitialState) { newValue in
                        if(newValue == "Off"){
                            shellyInfo.components[index].initial = 0
                        }
                        else if(newValue == "On"){
                            shellyInfo.components[index].initial = 1
                        }
                        else if(newValue == "Last"){
                            shellyInfo.components[index].initial = 2
                        }
                        else if(newValue == "Input"){
                            shellyInfo.components[index].initial = 3
                        }
                    }
                    .onAppear {
                        if(shellyInfo.components[index].initial == 0){
                            selectedInitialState = "Off"
                        }
                        else if(shellyInfo.components[index].initial == 1){
                            selectedInitialState = "On"
                        }
                        else if(shellyInfo.components[index].initial == 2){
                            selectedInitialState = "Last"
                        }
                        else if(shellyInfo.components[index].initial == 3){
                            selectedInitialState = "Input"
                        }
                    }
                    Toggle("Inverted Output: ", isOn: $shellyInfo.components[index].out_inverted)
                        .padding(.vertical, 2)
                    Toggle("Auto Off: ", isOn: $shellyInfo.components[index].auto_off)
                        .padding(.vertical, 2)
                    if (shellyInfo.components[index].auto_off) {
                        HStack {
                            Text("Auto Off Delay:")
                                .padding(.vertical, 5)
                            TextField("", text: Binding<String>(
                                get: { String(shellyInfo.components[index].auto_off_delay) },
                                set: { shellyInfo.components[index].auto_off_delay = Double($0) ?? 0.0 }
                            ))
                                .multilineTextAlignment(.trailing)
                                .padding(.vertical, 5)
                        }
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
