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
            guard let data = data else {
                return
            }
            self.currentPage += 1
            self.newsList.append(contentsOf: data)
            
            if !self.isTableEmpty {
                let indexPathsToReload = self.calculateIndexPathsToReload(from: data)
                self.view.populateTable(newsList: self.newsList, indexPathsToReload: indexPathsToReload)
            } else {
                self.isTableEmpty = false
                self.view.populateTable(newsList: self.newsList, indexPathsToReload: .none)
            }
        }
    }
    
    private func calculateIndexPathsToReload(from apiNews: [APINewsFeedData]) -> [IndexPath] {
        let startIndex = (newsList.count) - apiNews.count
        let endIndex = startIndex + apiNews.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
