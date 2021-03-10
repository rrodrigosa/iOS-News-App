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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    
    var presenter: RegisterPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RegisterPresenter(view: self)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            createErrorAlert(message: "Fill in the name field".localized)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            createErrorAlert(message: "Fill in the email field".localized)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            createErrorAlert(message: "Fill in the password field".localized)
            return
        }
        
        if let passwordConfirmation = passwordConfirmationTextField.text, passwordConfirmation.isEmpty {
            createErrorAlert(message: "Fill in the password confirmation field".localized)
            return
        }
        
        if passwordTextField.text != passwordConfirmationTextField.text {
            createErrorAlert(message: "Password fields do not match".localized)
            return
        }
        presenter?.signup(name: name, email: email, password: password)
    }
    
    func createErrorAlert(message: String) {
        let alert = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createSuccessfulAlert() {
        let message = "Registration successful".localized
        let alert = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
