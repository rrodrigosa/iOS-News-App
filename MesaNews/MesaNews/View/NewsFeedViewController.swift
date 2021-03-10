//
//  NewsFeedViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import UIKit

class NewsFeedViewController: UIViewController {

    private let mesaAPIService = MesaAPIService()
    var authToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("rdsa - (NewsFeedViewController) - viewDidLoad")

        mesaAPIService.newsFeedRequest(authToken: authToken) {
            (data: APINewsFeedData?, error: String?) in
            print("rdsa - (NewsFeedViewController) - data from api")
        }
    }

}
