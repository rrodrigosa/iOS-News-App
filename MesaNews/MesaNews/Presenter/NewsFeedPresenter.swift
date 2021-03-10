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
    
    required init(view: NewsFeedViewProtocol) {
        self.view = view
    }
    
    func newsFeedRequest(authToken: String) {
        mesaAPIService.newsFeedRequest(authToken: authToken) {
            (data: [APINewsFeedData]?, error: String?) in
            print("rdsa - (NewsFeedViewController) - data from api")
            guard let data = data else {
                return
            }
            self.newsList.append(contentsOf: data)
            self.view.populateTable(newsList: self.newsList)
        }
    }
    
}
