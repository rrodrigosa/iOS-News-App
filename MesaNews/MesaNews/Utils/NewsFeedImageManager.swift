//
//  NewsFeedImageManager.swift
//  MesaNews
//
//  Created by RodrigoSA on 3/10/21.
//

import Foundation
import Alamofire
import AlamofireImage

class NewsFeedImageManager {
    
    func configureImage(newsCell: APINewsFeedData, cell: NewsFeedCell, completion: @escaping (UIImage) -> Void) {
        let cellWidth = cell.newsFeedImageView.bounds.size.width
        let cellHeight = cell.newsFeedImageView.bounds.size.height
        let imageUrl = newsCell.imageUrl
        let imageName = newsCell.imageUrl?.deletingPathExtension().lastPathComponent
        let imageExtension = newsCell.imageUrl?.pathExtension
        
        guard let unwrappedImageUrl = imageUrl, let unwrappedImageName = imageName, let unwrappedImageExtension = imageExtension else {
            return
        }
        
        DispatchQueue.global().async {
            let imageExists = self.checkIfImageExists(imageName: unwrappedImageName, imageExtension: unwrappedImageExtension)
            if imageExists == true {
                let imagePath = self.imagePath(imageName: unwrappedImageName, imageExtension: unwrappedImageExtension)
                if let unwrappedImagePath = imagePath {
                    let resizedImage = self.configureResizeImage(path: unwrappedImagePath, cell: cell, imageName: unwrappedImageName, cellWidth: cellWidth, cellHeight: cellHeight)
                    if let unwrappedResizedImage = resizedImage {
                        DispatchQueue.main.async {
                            completion(unwrappedResizedImage)
                        }
                    }
                }
            } else {
                self.downloadManager(imageUrl: unwrappedImageUrl, imageName: unwrappedImageName, imageExtension: unwrappedImageExtension) { path in
                    if let unwrappedImagePath = path {
                        let resizedImage = self.configureResizeImage(path: unwrappedImagePath, cell: cell, imageName: unwrappedImageName, cellWidth: cellWidth, cellHeight: cellHeight)
                        if let unwrappedResizedImage = resizedImage {
                            DispatchQueue.main.async {
                                completion(unwrappedResizedImage)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func checkIfImageExists(imageName: String, imageExtension: String) -> Bool? {
        if let imagePath = imagePath(imageName: imageName, imageExtension: imageExtension),
           let _ = FileManager.default.contents(atPath: imagePath.path) {
            return true
        }
        return false
    }
    
    private func downloadManager(imageUrl: URL, imageName: String, imageExtension: String, completion: @escaping (URL?) -> Void) {
        let dataRequest = AF.request(imageUrl).responseImage { response in
            if case .success(let image) = response.result {
                let path = self.storeImage(image: image, imageName: imageName, imageExtension: imageExtension)
                completion(path)
            } else {
                completion(nil)
            }
        }
    }

    func configureResizeImage(path: URL, cell: NewsFeedCell, imageName: String, cellWidth: CGFloat, cellHeight: CGFloat) -> UIImage? {
        let size = CGSize(width: cellWidth, height: cellHeight)
        let resizedImage = resizeImage(at: path, for: size)
        if let unwrappedResizedImage = resizedImage {
            return unwrappedResizedImage
        }
        return nil
    }
    
    private func resizeImage(at url: URL, for size: CGSize) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height)
        ]
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }
        return UIImage(cgImage: image)
    }
    
    func storeImage(image: UIImage, imageName: String, imageExtension: String) -> URL? {
        if let jpgRepresentation = image.jpegData(compressionQuality: 1) {
            if let imagePath = imagePath(imageName: imageName, imageExtension: imageExtension) {
                do  {
                    try jpgRepresentation.write(to: imagePath,
                                                options: .atomic)
                    return imagePath
                } catch let err {
                    return nil
                }
            }
        }
        return nil
    }
    
    func imagePath(imageName: String, imageExtension: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentPath = fileManager.urls(for: .documentDirectory,
                                                  in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        let appendedDocumentPath = documentPath.appendingPathComponent(imageName).appendingPathExtension(imageExtension)
        return appendedDocumentPath
    }
}
