//
//  NewsFeedViewController.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import UIKit

protocol NewsFeedViewProtocol: class {
    func createAlert(message: String)
    func populateTable(newsList: [APINewsFeedData], indexPathsToReload: [IndexPath]?)
}

class NewsFeedViewController: UIViewController, NewsFeedViewProtocol, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    private var newsList: [APINewsFeedData] = []
    private var filteredNewsList: [APINewsFeedData] = []
    
    var presenter: NewsFeedPresenter?
    var authToken = ""
    
    @IBOutlet weak var newsFeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        if indexPaths.contains(where: isLastCell) {
            presenter?.newsFeedRequest(authToken: authToken)
        }
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= newsList.count - 1
    }
    
    // MARK: - Helpers
    func populateTable(newsList: [APINewsFeedData], indexPathsToReload: [IndexPath]?) {
        self.newsList = newsList
        guard let unwrappedIndexPathsToReload = indexPathsToReload else {
            newsFeedTableView.reloadData()
            return
        }
        addNewTableRows(tableView: newsFeedTableView, indexPathsToReload: unwrappedIndexPathsToReload)
    }
    
    func addNewTableRows(tableView: UITableView, indexPathsToReload: [IndexPath]) {
        newsFeedTableView.beginUpdates()
        newsFeedTableView.insertRows(at: indexPathsToReload, with: .automatic)
        newsFeedTableView.endUpdates()
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureViewDidLoad() {
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        newsFeedTableView.prefetchDataSource = self
        newsFeedTableView.keyboardDismissMode = .onDrag
        
        print("rdsa - (NewsFeedViewController) - viewDidLoad - token: \(authToken)")
        presenter = NewsFeedPresenter(view: self)
        presenter?.newsFeedRequest(authToken: authToken)
    }

}
