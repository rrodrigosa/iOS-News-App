//
//  AuthPresenter.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import Foundation

protocol AuthPresenterProtocol {
    init(view: AuthViewProtocol)
    func signin(email: String, password: String)
}

class AuthPresenter: AuthPresenterProtocol {
    unowned let view: AuthViewProtocol
    private let mesaAPIService = MesaAPIService()
    private var apiAuthDataSet: APIAuthDataSet?
    
    required init(view: AuthViewProtocol) {
        self.view = view
    }
    
    func signin(email: String, password: String) {
//        mesaAPIService.signinUserRequest(email: email, password: password)
        mesaAPIService.signinUserRequest(email: "john@doe.com", password: "123456") {
            (data: APIAuthDataSet?, error: String?) in
            print("rdsa - (presenter) | token: \(String(describing: data?.token))")
            guard let data = data else {
                return
            }
            self.view.createAlert(message: message)
        }
    }
    
}
