//
//  APINewsFeedDataSet.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/9/21.
//

import Foundation

struct APINewsFeedDataSet: Codable {
    var pagination: APINewsFeedDataPagination?
    var data: [APINewsFeedData]?
    
    enum CodingKeys: String, CodingKey {
        case pagination, data
    }
}

struct APINewsFeedDataPagination: Codable {
    let currentPage: Int?
    let perPage: Int?
    let totalPages: Int?
    let totalItems: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case perPage = "per_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
    }
}

struct APINewsFeedData: Codable {
    let title: String?
    let description: String?
    let content: String?
    let author: String?
    let publishedAt: String?
    var highlight: Bool?
    let url: URL?
    let imageUrl: URL?
    
    var publishDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case content = "content"
        case author = "author"
        case publishedAt = "published_at"
        case highlight = "highlight"
        case url = "url"
        case imageUrl = "image_url"
    }
    
}
