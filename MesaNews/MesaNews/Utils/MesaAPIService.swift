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
                    print("rdsa - (MesaAPIService) - sign IN token: \(self.authToken)")
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
                        completion(nil, "error message")
                        return
                    }
                        
                    guard let apiReturnData = self.decodeAPIRegisterDataSet(data: responseData) else {
                        completion(nil, "error message")
                        return
                    }
                    self.authToken = apiReturnData.token
                    print("rdsa - (MesaAPIService) - sign UP token: \(self.authToken)")
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
    
    func newsFeedRequest(authToken: String, completion:  @escaping (_ apiNewsFeedData: APINewsFeedData?, _ error: String?) -> Void) {
        self.authToken = authToken
        let newsUrl = "/v1/client/news?current_page=&per_page=&published_at="
        let fullUrl = baseUrl + newsUrl
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)",
            "Accept": "application/json"
        ]

        AF.request(fullUrl, headers: headers).responseJSON { response in
            print("rdsa - (MesaAPIService) - responseJSON")
            guard let responseData = response.data else {
                completion(nil, "error message")
                return
            }

            guard let apiReturnData = self.decodeAPINewsFeedData(data: responseData) else {
                completion(nil, "error message")
                return
            }
            print("rdsa - (MesaAPIService) - completion")
            completion(apiReturnData, nil)
        }
    }
    
    func decodeAPINewsFeedData(data: Data) -> APINewsFeedData? {
        do {
            let decodedData = try JSONDecoder().decode(APINewsFeedData.self,
                                                       from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
}
