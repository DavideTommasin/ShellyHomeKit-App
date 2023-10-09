//
//  ShellyComponents.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellyComponents: View {
    @Binding var shellyInfo: ShellyInfo
    
    var body: some View {
        Text("Components").font(.title)
        
        VStack {
            ForEach(shellyInfo.components.indices, id: \.self) { index in
                if shellyInfo.components[index].type == ShellyType.kSwitch.rawValue {
                    Shelly1Switch(shellyInfo: $shellyInfo, index: index)    
                }else if shellyInfo.components[index].type == ShellyType.kGarageDoorOpener.rawValue {
                    Shelly1GarageOpener(shellyInfo: $shellyInfo, index: index)
                }
            }
        }
    }
}
