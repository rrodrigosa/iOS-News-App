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
    
    required init(view: AuthViewProtocol) {
        self.view = view
    }
    
    func signin(email: String, password: String) {
        mesaAPIService.signinUserRequest(email: email, password: password) {
            (data: APIAuthDataSet?, error: String?) in
            if let unwrappedError = error {
                self.view.createAlert(message: unwrappedError)
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let authToken = data.token {
                self.view.goToNewsFeed(authToken: authToken)
            } else if let message = data.message {
                self.view.createAlert(message: message)
            }
        }
    }
    
}
