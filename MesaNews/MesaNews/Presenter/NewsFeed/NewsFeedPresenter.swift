//
//  NewsFeedPresenter.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import Foundation

protocol NewsFeedPresenterProtocol {
    init(view: NewsFeedViewProtocol)
    func newsFeedRequest(authToken: String)
    func newsFeedFetch(indexPaths: [IndexPath], authToken: String)
    func isFavoriteNews(title: String?)
}

class NewsFeedPresenter: NewsFeedPresenterProtocol {
    unowned let view: NewsFeedViewProtocol
    private let mesaAPIService = MesaAPIService()
    private var newsList: [APINewsFeedData] = []
    private var currentPage = 1
    private var isTableEmpty = true
    
    required init(view: NewsFeedViewProtocol) {
        self.view = view
    }
    
    func newsFeedRequest(authToken: String) {
        mesaAPIService.newsFeedRequest(authToken: authToken, currentPage: currentPage) {
            (data: [APINewsFeedData]?, error: String?) in
            if let unwrappedError = error {
                self.view.createAlert(message: unwrappedError)
                return
            }
            
            guard let data = data else {
                return
            }
            self.currentPage += 1
            self.newsList.append(contentsOf: data)
            self.convertDate()
            self.sortByDate()
            
            if !self.isTableEmpty {
                let indexPathsToReload = self.calculateIndexPathsToReload(from: data)
                self.view.addTableRows(newsList: self.newsList, indexPathsToReload: indexPathsToReload)
            } else {
                self.isTableEmpty = false
                self.view.populateTable(newsList: self.newsList)
            }
        }
    }
    
    private func convertDate() {
        for i in newsList.indices {
            if let publishDate = newsList[i].publishedAt {
                newsList[i].publishDate = convertStringToDate(dateString: publishDate)
            }
        }
    }
    private func convertStringToDate (dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    private func sortByDate() {
        newsList.sort() {
            guard let firstDate = $0.publishDate, let secondDate = $1.publishDate else {
                return false
            }
            return firstDate > secondDate
        }
    }
    
    private func calculateIndexPathsToReload(from apiNews: [APINewsFeedData]) -> [IndexPath] {
        let startIndex = (newsList.count) - apiNews.count
        let endIndex = startIndex + apiNews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func newsFeedFetch(indexPaths: [IndexPath], authToken: String) {
        if indexPaths.contains(where: isLastCell) {
            newsFeedRequest(authToken: authToken)
        }
    }
    
    func isLastCell(indexPath: IndexPath) -> Bool {
        return indexPath.row >= newsList.count - 1
    }
    
    func isFavoriteNews(title: String?) {
        let favoriteManager = FavoriteManager()
        let active = favoriteManager.isFavoriteNewsAdded(title: title)
        view.isFavoriteNewsResult(result: active)
    }
    
}
