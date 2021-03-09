//
//  APISignInDataSet.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/8/21.
//

import Foundation

struct APIAuthDataSet: Codable {
    let token: String?
    let code: String?
    let message: String?
}
