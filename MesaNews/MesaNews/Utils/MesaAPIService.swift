//
//  MesaService.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/8/21.
//

import Foundation
import Alamofire

class MesaAPIService {
    let baseUrl = "https://mesa-news-api.herokuapp.com"
    var authToken = ""
    
    // MARK: -> signinUserRequest
    func signinUserRequest(email: String, password: String, completion:  @escaping (_ apiAuthDataSet: APIAuthDataSet?, _ error: String?) -> Void) {
        let signinUrl = "/v1/client/auth/signin"
        let fullUrl = baseUrl + signinUrl // fullUrl: https://mesa-news-api.herokuapp.com/v1/client/auth/signin
        
        let parameters: [String:String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(fullUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).response { response in
                    
                    guard let responseData = response.data else {
                        completion(nil, "error message")
                        return
                    }
                        
                    guard let apiReturnData = self.decodeAPIAuthDataSet(data: responseData) else {
                        completion(nil, "error message")
                        return
                    }
                    
                    guard let token = apiReturnData.token else {
                        return
                    }
                    self.authToken = token
                    completion(apiReturnData, "")
        }
    }
    
    func decodeAPIAuthDataSet(data: Data) -> APIAuthDataSet? {
        do {
            let decodedData = try JSONDecoder().decode(APIAuthDataSet.self,
                                                       from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
}
