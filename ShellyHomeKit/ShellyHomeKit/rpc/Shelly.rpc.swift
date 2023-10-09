//
//  Shelly.rpc
//  ShellyHomeKit
//
//  Created by Davide Tommasin on 09/07/23.
//

import Alamofire
import Foundation

func rpcCall(ipHost: String, method: String, params: [String:Any], auth: Authentication, completion: @escaping ([String: Any]) -> Void){
    
    let parameters: [String: Any] =
    [
        "id": 1,
        "method": method,
        "auth":
            [
                "realm": auth.realm,
                "nonce": auth.nonce,
                "username": auth.username,
                "cnonce": auth.cnonce,
                "algorithm": auth.algorithm,
                "response": auth.response
            ] as [String : Any],
        "params": params
    ]
    
    AF.request(ipHost+"/rpc", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil){$0.timeoutInterval = 5}
        .validate(statusCode: 200 ..< 299)
        .responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        completion([:])
                        return
                    }
                    completion(jsonObject)
                    return
                } catch {
                    completion([:])
                    return
                }
            case .failure(_):
                if let statusCode = response.response?.statusCode, statusCode == 401 {
                    showAlert(titleMessage: "Authentication Fail", errorMessage: "Error to authenticate.")
                    completion([:])
                    return
                }
                else{
                    showAlert(titleMessage: "Network Error", errorMessage: "Error to establishing a connection.")
                    completion([:])
                    return
                }
            }
        }
}
