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
    var authToken: String?
    
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
                    
                    self.authToken = apiReturnData.token
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
    
    func signupUserRequest(name: String, email: String, password: String, completion:  @escaping (_ apiRegisterDataSet: APIRegisterDataSet?, _ error: String?) -> Void) {
        let signupUrl = "/v1/client/auth/signup"
        let fullUrl = baseUrl + signupUrl
        
        let parameters: [String:String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        AF.request(fullUrl,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default).response { response in
                    
                    guard let responseData = response.data else {
                        print("rdsa - API 1")
                        completion(nil, "error message")
                        return
                    }
                        
                    guard let apiReturnData = self.decodeAPIRegisterDataSet(data: responseData) else {
                        print("rdsa - API 2")
                        completion(nil, "error message")
                        return
                    }
                    
                    print("rdsa - API 3")
                    self.authToken = apiReturnData.token
                    completion(apiReturnData, "")
        }
    }
    
    func decodeAPIRegisterDataSet(data: Data) -> APIRegisterDataSet? {
        do {
            let decodedData = try JSONDecoder().decode(APIRegisterDataSet.self,
                                                       from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
