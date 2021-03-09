//
//  ViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/4/21.
//

import UIKit

class ViewController: UIViewController {

    let mesa = MesaAPIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mesa.signinUserRequest(email: "john@doe.com", password: "123456") {
            (data: APIAuthDataSet?, error: String?) in
            print("rdsa - token: \(String(describing: data?.token))")
        }
    }


}

