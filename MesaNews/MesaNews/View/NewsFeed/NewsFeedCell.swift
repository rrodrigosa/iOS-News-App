//
//  NewsFeedCell.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/10/21.
//

import UIKit

class NewsFeedCell: UITableViewCell {
    @IBOutlet weak var newsFeedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func addFavoriteButton(_ sender: Any) {
        let favoriteManager = FavoriteManager()
        favoriteManager.favoriteNews(title: titleLabel.text)
    }
    
    let newsFeedImageManager = NewsFeedImageManager()
    
    func configureCell(newsList: [APINewsFeedData], cell: NewsFeedCell, indexRow: Int) {
        let newsCell = newsList[indexRow]
        titleLabel.text = newsCell.title
        descriptionLabel.text = newsCell.description
        newsFeedImageView.image = nil
        
        newsFeedImageManager.configureImage(newsCell: newsCell, cell: cell) { (image) in
            self.addImageToCell(cell: cell, spinner: cell.imageViewActivityIndicator, image: image)
        }
    }
    
    private func addImageToCell(cell: NewsFeedCell, spinner: UIActivityIndicatorView, image: UIImage) {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            cell.newsFeedImageView.image = image
        }
    }
}
