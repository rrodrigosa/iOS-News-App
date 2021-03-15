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
    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    var newsUrl: URL?
    var newsTitle: String?
    var isFavoriteNews: Bool?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        newsDetailsWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        newsDetailsWebView.uiDelegate = self
        view = newsDetailsWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = newsUrl
        let myRequest = URLRequest(url: myURL!)
        newsDetailsWebView.load(myRequest)
        
        if let isFavoriteNews = isFavoriteNews {
            if isFavoriteNews {
                changeButtonImage(sender: addFavoriteButton, active: isFavoriteNews)
            }
        }
    }
    
    @IBAction func addFavoriteButton(_ sender: UIBarButtonItem) {
        
        let favoriteManager = FavoriteManager()
        let active = favoriteManager.favoriteNews(title: newsTitle)
        changeButtonImage(sender: sender, active: active)
    }
    
    func changeButtonImage(sender: UIBarButtonItem, active: Bool) {
        var star = UIImage()
        if active {
            star = #imageLiteral(resourceName: "filled_star_30px").withRenderingMode(.alwaysTemplate);
        } else {
            star = #imageLiteral(resourceName: "empty_star_30px").withRenderingMode(.alwaysTemplate);
        }
        sender.image = star
    }

}
