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
        // Do any additional setup after loading the view.
        presenter = RegisterPresenter(view: self)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            createErrorAlert(message: "Fill in the name field")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            createErrorAlert(message: "Fill in the email field")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            createErrorAlert(message: "Fill in the password field")
            return
        }
        
        if let passwordConfirmation = passwordConfirmationTextField.text, passwordConfirmation.isEmpty {
            createErrorAlert(message: "Fill in the password confirmation field")
            return
        }
        
        if passwordTextField.text != passwordConfirmationTextField.text {
            createErrorAlert(message: "Password fields do not match")
            return
        }
//        presenter?.signup(name: name, email: email, password: password)
        
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
