//
//  NewsDetailsViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/10/21.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var newsDetailsWebView: WKWebView!
    var newsUrl: URL?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        newsDetailsWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        newsDetailsWebView.uiDelegate = self
        view = newsDetailsWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let myURL = newsUrl
        let myRequest = URLRequest(url: myURL!)
        newsDetailsWebView.load(myRequest)
    }
    
    @IBAction func addFavoriteButton(_ sender: Any) {
        
    }

}
