//
//  RegisterPresenter.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import Foundation

protocol RegisterPresenterProtocol {
    init(view: RegisterViewProtocol)
    func signup(name: String, email: String, password: String)
}

class RegisterPresenter: RegisterPresenterProtocol {
    unowned let view: RegisterViewProtocol
    private let mesaAPIService = MesaAPIService()
    
    required init(view: RegisterViewProtocol) {
        self.view = view
    }
    
    func signup(name: String, email: String, password: String) {
        mesaAPIService.signupUserRequest(name: name, email: email, password: password) {
            (data: APIRegisterDataSet?, error: String?) in
            guard let data = data else {
                return
            }
            
            if data.token != nil {
                self.view.createSuccessfulAlert()
            } else {
                self.view.createErrorAlert(message: "decode errors")
            }
        }
    }
    
    
    
}
