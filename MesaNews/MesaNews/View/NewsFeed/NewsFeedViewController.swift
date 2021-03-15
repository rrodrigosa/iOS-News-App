//
//  NewsFeedViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import UIKit

protocol NewsFeedViewProtocol: class {
    func createAlert(message: String)
    func populateTable(newsList: [APINewsFeedData])
    func addTableRows(newsList: [APINewsFeedData], indexPathsToReload: [IndexPath])
    func isFavoriteNewsResult(result: Bool)
}

class NewsFeedViewController: UIViewController, NewsFeedViewProtocol, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private var isFavoriteNews: Bool?
    private var newsList: [APINewsFeedData] = []
    private var filteredNewsList: [APINewsFeedData] = []
    var presenter: NewsFeedPresenter?
    var authToken = ""
    let newsDetailsIdentifier = "NewsDetailsIdentifier"
    
    @IBOutlet weak var fetchingIndicatorView: UIView!
    @IBOutlet weak var fetchingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsFeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewDidLoad()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCell
        cell.configureCell(newsList: newsList, cell: cell, indexRow: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        presenter?.newsFeedFetch(indexPaths: indexPaths, authToken: authToken)
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: newsDetailsIdentifier, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == newsDetailsIdentifier, let destination = segue.destination as? NewsDetailsViewController {
            let indexPath = sender as? IndexPath
            if let unwrappedSelectedRow = indexPath?.row {
                destination.newsUrl = newsList[unwrappedSelectedRow].url
                destination.newsTitle = newsList[unwrappedSelectedRow].title
                presenter?.isFavoriteNews(title: destination.newsTitle)
                
                if let isFavoriteNews = isFavoriteNews {
                    destination.isFavoriteNews = isFavoriteNews
                }
            }
        }
    }
    
    func isFavoriteNewsResult(result: Bool) {
        isFavoriteNews = result
    }
    
    // MARK: - Helpers
    func populateTable(newsList: [APINewsFeedData]) {
        fetchingIndicatorView.isHidden = true
        fetchingActivityIndicator.stopAnimating()
        newsFeedTableView.isHidden = false
        self.newsList = newsList
        newsFeedTableView.reloadData()
    }
    
    func addTableRows(newsList: [APINewsFeedData], indexPathsToReload: [IndexPath]) {
        self.newsList = newsList
        addNewTableRows(tableView: newsFeedTableView, indexPathsToReload: indexPathsToReload)
    }
    
    func addNewTableRows(tableView: UITableView, indexPathsToReload: [IndexPath]) {
        newsFeedTableView.beginUpdates()
        newsFeedTableView.insertRows(at: indexPathsToReload, with: .automatic)
        newsFeedTableView.endUpdates()
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry".localized, style: .default, handler: { action in
            self.presenter?.newsFeedRequest(authToken: self.authToken)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureViewDidLoad() {
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        newsFeedTableView.prefetchDataSource = self
        newsFeedTableView.keyboardDismissMode = .onDrag
        presenter = NewsFeedPresenter(view: self)
        presenter?.newsFeedRequest(authToken: authToken)
    }

}
