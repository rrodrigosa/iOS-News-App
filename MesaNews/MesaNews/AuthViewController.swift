//
//  ViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/4/21.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let newsFeedIdentifier = "NewsFeedIdentifier"
    let registerIdentifier = "RegisterIdentifier"
    
    let mesa = MesaAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mesa.signinUserRequest(email: "john@doe.com", password: "123456") {
            (data: APIAuthDataSet?, error: String?) in
            print("rdsa - token: \(String(describing: data?.token))")
            
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
    }
    
    @IBAction func registerButton(_ sender: Any) {
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

