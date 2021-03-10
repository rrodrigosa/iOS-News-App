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
                        completion(nil, ErrorMessage.apiNoData.message)
                        return
                    }
                        
                    guard let apiReturnData = self.decodeAPIAuthDataSet(data: responseData) else {
                        completion(nil, ErrorMessage.decode.message)
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
                        completion(nil, ErrorMessage.apiNoData.message)
                        return
                    }
                        
                    guard let apiReturnData = self.decodeAPIRegisterDataSet(data: responseData) else {
                        completion(nil, ErrorMessage.decode.message)
                        return
                    }
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
    
    func newsFeedRequest(authToken: String, currentPage: Int, completion:  @escaping (_ apiNewsFeedData: [APINewsFeedData]?, _ error: String?) -> Void) {
        self.authToken = authToken
        let newsUrl = "/v1/client/news?current_page=&per_page=&published_at="
        let fullUrl = baseUrl + newsUrl
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)",
            "Accept": "application/json"
        ]
        
        let parameters: [String:Int] = [
            "current_page": currentPage
        ]

        AF.request(fullUrl, parameters: parameters, headers: headers).responseJSON { response in
            guard let responseData = response.data else {
                completion(nil, ErrorMessage.apiNoData.message)
                return
            }
            guard let apiReturnData = self.decodeAPINewsFeedDataSet(data: responseData) else {
                completion(nil, ErrorMessage.decode.message)
                return
            }
            guard let results = apiReturnData.data else {
                completion(nil, ErrorMessage.resultNoData.message)
                return
            }
            completion(results, nil)
        }
    }
    
    func decodeAPINewsFeedDataSet(data: Data) -> APINewsFeedDataSet? {
        do {
            let decodedData = try JSONDecoder().decode(APINewsFeedDataSet.self,
                                                       from: data)
            return decodedData
        } catch {
            return nil
        }
    }
    
}

private enum ErrorMessage: Error {
    case apiNoData
    case decode
    case resultNoData
    
    var message: String {
        switch self {
        case .apiNoData:
            return "No data received from API".localized
        case .decode:
            return "Could not decode API data".localized
        case .resultNoData:
            return "No news data received from API".localized
        }
    }
}
