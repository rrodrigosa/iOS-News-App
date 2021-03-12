//
//  FavoriteManager.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/12/21.
//

import Foundation

struct FavoriteManager {
    
    func favoriteNews(title: String?) {
        let key = "arrayFavoriteNews"
        let defaults = UserDefaults.standard
        let favoriteNews = defaults.object(forKey: key) as? [String] ?? [String]()
        print("rdsa - arrayFavoriteNews: \(favoriteNews)")
        
        var newFavoriteNews = favoriteNews
        var flag = false
        if let newsTitle = title {
            for i in favoriteNews.indices {
                if newsTitle == favoriteNews[i] {
                    newFavoriteNews.remove(at: i)
                    defaults.set(newFavoriteNews, forKey: key)
                    flag = true
                    print("rdsa - Removed")
                    return
                }
            }
            if !flag {
                newFavoriteNews.append(newsTitle)
                defaults.set(newFavoriteNews, forKey: key)
                print("rdsa - Added")
            }
        }
    }
    
}
