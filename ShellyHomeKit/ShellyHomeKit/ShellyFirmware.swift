//
//  ShellyFirmware.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellyFirmware: View {
    @State var shellyInfo: ShellyInfo
    
    var body: some View {
        Text("Firmware").font(.title)
        
        VStack {
            Form {
                CustomText(labelLeft: "Version:", labelRight: String(shellyInfo.version))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                
                Text("Build:\n"+String(shellyInfo.fw_build))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                HStack
                {
                    Text("Update:")
                        .padding(.vertical, 5)
                    Spacer()
                    Button(action: {
                    }) {
                        Text("    Check    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }
                HStack
                {
                    Text("Revert to Stock:")
                        .padding(.vertical, 5)
                    Spacer()
                    Button(action: {
                    }) {
                        Text("    Revert    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                }
            }
        }
    }
}
