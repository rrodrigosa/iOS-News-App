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
        let imageUrl = newsCell.imageUrl
        let imageName = newsCell.imageUrl?.deletingPathExtension().lastPathComponent
        let imageExtension = newsCell.imageUrl?.pathExtension
        print("rdsa - configureImage | extension: \(imageExtension) | name: \(imageName)")
        
        guard let unwrappedImageUrl = imageUrl, let unwrappedImageName = imageName, let unwrappedImageExtension = imageExtension else {
            return
        }
        
        DispatchQueue.global().async {
            self.downloadManager(imageUrl: unwrappedImageUrl, imageName: unwrappedImageName, imageExtension: unwrappedImageExtension) { path in
                if let unwrappedImagePath = path {
                    let resizedImage = self.configureResizeImage(path: unwrappedImagePath, cell: cell, imageName: unwrappedImageName)
                    if let unwrappedResizedImage = resizedImage {
                        DispatchQueue.main.async {
                            completion(unwrappedResizedImage)
                        }
                    }
                }
            }
        }
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

    func configureResizeImage(path: URL, cell: NewsFeedCell, imageName: String) -> UIImage? {
        let width = cell.newsFeedImageView.bounds.size.width
        let height = cell.newsFeedImageView.bounds.size.height
        let size = CGSize(width: width, height: height)
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
//        print("rdsa - appendedDocumentPath: \(appendedDocumentPath)")
        return appendedDocumentPath
    }
}
