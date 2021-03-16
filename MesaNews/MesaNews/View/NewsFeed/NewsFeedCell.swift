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
    @IBOutlet weak var addFavoriteButton: UIButton!
    
    let newsFeedImageManager = NewsFeedImageManager()
    var presenter: NewsFeedPresenter?
    var indexPath: IndexPath?
    
    @IBAction func addFavoriteButton(_ sender: UIButton) {
        let favoriteManager = FavoriteManager()
        let active = favoriteManager.favoriteNews(title: titleLabel.text)
        changeButtonImage(sender: sender, active: active)
        
        if let indexPath = indexPath {
            presenter?.updateNewsList(indexRow: indexPath.row, active: active)
        }
    }
    
    func configureCell(newsList: [APINewsFeedData], cell: NewsFeedCell, indexRow: Int, indexPath: IndexPath, presenter: NewsFeedPresenter?) {
        self.presenter = presenter
        self.indexPath = indexPath
        let newsCell = newsList[indexRow]
        let favoriteManager = FavoriteManager()
        let active = favoriteManager.isFavoriteNewsAdded(title: newsCell.title)
        changeButtonImage(sender: addFavoriteButton, active: active)
        
        
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
    
    func changeButtonImage(sender: UIButton, active: Bool) {
        var star = UIImage()
        if active {
            star = #imageLiteral(resourceName: "filled_star_30px").withRenderingMode(.alwaysTemplate);
        } else {
            star = #imageLiteral(resourceName: "empty_star_30px").withRenderingMode(.alwaysTemplate);
        }
        sender.setImage(star, for: .normal)
    }
}
