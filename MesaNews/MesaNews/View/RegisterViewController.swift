//
//  RegisterViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import UIKit

protocol RegisterViewProtocol: class {
    func createErrorAlert(message: String)
    func createSuccessfulAlert()
}

class RegisterViewController: UIViewController, RegisterViewProtocol {
    
    
    var presenter: RegisterPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func createErrorAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createSuccessfulAlert() {
        let message = "Registration successful" //localize
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
