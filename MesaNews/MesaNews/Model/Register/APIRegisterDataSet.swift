//
//  APIRegisterDataSet.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import Foundation

struct APIRegisterDataSet: Codable {
    let token: String?
    let error: APIRegisterError?
}

struct APIRegisterError: Codable {
    let code: String?
    let field: String?
    let message: String?
}
