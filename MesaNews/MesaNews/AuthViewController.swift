//
//  ViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/4/21.
//

import UIKit

protocol AuthViewProtocol: class {
    func createAlert(message: String)
}

class AuthViewController: UIViewController, AuthViewProtocol {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let newsFeedIdentifier = "NewsFeedIdentifier"
    let registerIdentifier = "RegisterIdentifier"
    
    let mesa = MesaAPIService()
    
    var presenter: AuthPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        presenter = AuthPresenter(view: self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
//        mesa.signinUserRequest(email: "john@doe.com", password: "123456") {
//            (data: APIAuthDataSet?, error: String?) in
//            print("rdsa - token: \(String(describing: data?.token))")
//            
//            self.performSegue(withIdentifier: self.newsFeedIdentifier, sender: sender)
//        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        presenter?.signin(email: email, password: password)
    }
    
    func createAlert(message: String) {
        // dialog
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style {
              case .default:
                    print("default")
              case .cancel:
                    print("cancel")
              case .destructive:
                    print("destructive")
        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // add another condition? if user has token, allow navigation
        if  segue.identifier == newsFeedIdentifier {
            let destination = segue.destination as? NewsFeedViewController
            print("news feed interface")
        } else if segue.identifier == registerIdentifier {
            let destination = segue.destination as? RegisterViewController
            print("register interface")
        }
    }

}

