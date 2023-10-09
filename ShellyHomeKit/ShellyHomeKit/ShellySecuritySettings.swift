//
//  ShellySecuritySettings.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellySecuritySettings: View {
    @State var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
    @State private var isLogOutBtn = false
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    
    @State private var shouldNavigateToMainView = false
    var body: some View {
        Text("Security Settings").font(.title)
        
        VStack {
            Form {
                if(shellyInfo.auth_en){
                    HStack {
                        Text("Old Password:")
                            .padding(.vertical, 5)
                        TextField("", text: $oldPassword)
                            .multilineTextAlignment(.trailing)
                            .padding(.vertical, 5)
                    }
                }
                HStack {
                    Text("New Password:")
                        .padding(.vertical, 5)
                    TextField("", text: $newPassword)
                        .multilineTextAlignment(.trailing)
                        .padding(.vertical, 5)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        SaveNewPassword()
                    }) {
                        Text("    Save    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .opacity(isSavingBtn ? 0.5 : 1.0)
                            .disabled(isSavingBtn)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        shouldNavigateToMainView = true
                    }) {
                        Text("    Log Out    ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .opacity(isLogOutBtn ? 0.5 : 1.0)
                            .disabled(isLogOutBtn)
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
    
    func SaveNewPassword(){
        isSavingBtn = true
        var oldPswOk: Bool = false
        
        if(shellyInfo.auth_en){
            let oldHa1 = calculateSHA256Hash(inputString: "admin:\(shellyInfo.device_id):\(oldPassword)")
            if (shellyInfo.auth.ha1 != oldHa1){
                oldPswOk = false
                showAlert(titleMessage: "Error change password", errorMessage: "Invalid old password.")
            }
            else {
                oldPswOk = true
            }
        }
        if(oldPswOk){
            var newHa1: String = ""
            if(!newPassword.isEmpty){
                newHa1 = calculateSHA256Hash(inputString: "admin:\(shellyInfo.device_id):\(newPassword)")
            }
            
            ShellySetAuth(shellyInfoIn: shellyInfo, newHa1: newHa1, button: $isSavingBtn)
            shouldNavigateToMainView = true
        }
        else{
            isSavingBtn = false
        }
    }
}
