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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
    */

}
