//
//  ShellyHomeKitSettings.swift
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 21/06/23.
//

import SwiftUI

struct ShellyHomeKitSettings: View {
    @State var shellyInfo: ShellyInfo
    
    @State private var isSavingBtn = false
    
    @State private var codeHomekit: String = ""
    @State private var idHomeKit: String = ""
    @State private var urlQrCode: String = ""
    
    var body: some View {
        Text("HomeKit Settings").font(.title)
        
        VStack {
            Form {
                CustomText(labelLeft: "Paired:", labelRight: String(shellyInfo.hap_paired))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                CustomText(labelLeft: "Connections Pending:", labelRight: String(shellyInfo.hap_ip_conns_pending))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                CustomText(labelLeft: "Connections Active:", labelRight: String(shellyInfo.hap_ip_conns_active))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                CustomText(labelLeft: "Connections Max:", labelRight: String(shellyInfo.hap_ip_conns_max))
                    .padding(.vertical, 5)
                    .multilineTextAlignment(.leading)
                HStack {
                    Spacer()
                    Button(action: {
                        HAPSetup(shellyInfoIn: shellyInfo, codeHomekit: $codeHomekit, idHomeKit: $idHomeKit, urlQrCode: $urlQrCode, button: $isSavingBtn)
                    }) {
                        Text(shellyInfo.hap_paired == false ? "   Setup   " : "   Reset   ")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(30)
                    }
                    .opacity(isSavingBtn ? 0.5 : 1.0)
                    .disabled(isSavingBtn)
                    Spacer()
                }
                if (!urlQrCode.isEmpty){
                    HStack{
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 31.5)
                                .stroke(Color.black, lineWidth: 7)
                            
                            VStack{
                                HStack{
                                    Image(systemName: "homekit")
                                        .font(.system(size: 50))
                                    Text(codeHomekit)
                                        .font(.system(size: 20))
                                }
                                Spacer()
                                Image(uiImage: generateQRCodeImage() ?? UIImage())
                                    .resizable()
                                    .interpolation(.none)
                            }
                            .frame(width: 190, height: 255)
                        }
                        .frame(width: 200, height: 297)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func generateQRCodeImage() -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        let data = Data(urlQrCode.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
