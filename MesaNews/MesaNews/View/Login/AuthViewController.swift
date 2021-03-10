//
//  ViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/4/21.
//

import UIKit

protocol AuthViewProtocol: class {
    func createAlert(message: String)
    func goToNewsFeed(authToken: String)
}

class AuthViewController: UIViewController, AuthViewProtocol {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let newsFeedIdentifier = "NewsFeedIdentifier"
    let registerIdentifier = "RegisterIdentifier"
    var presenter: AuthPresenter?
    var authToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AuthPresenter(view: self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        presenter?.signin(email: email, password: password)
    }
    
    func goToNewsFeed(authToken: String) {
        self.authToken = authToken
        self.performSegue(withIdentifier: newsFeedIdentifier, sender: nil)
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsFeedIdentifier {
            let destination = segue.destination as? NewsFeedViewController
            destination?.authToken = authToken
        } else if segue.identifier == registerIdentifier {
            let destination = segue.destination as? RegisterViewController
        }
    }

}

