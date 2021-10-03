//
//  LazyImageLoader.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import UIKit

/// Lazy Image Loading Class
class LazyImageLoader: UIImageView {

    var urlString: String?
    
    func downloadImage(imageURL: String) {
        let cache = NSCache<NSString, UIImage>()
        image = nil
        if let image = cache.object(forKey: imageURL as NSString) {
            DispatchQueue.main.async {
                self.image = image
            }
            return
        }
        urlString = imageURL
        guard let url = URL(string: imageURL) else { return }
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            if let data = try? Data(contentsOf: url),
                let img = UIImage(data: data) {
                cache.setObject(img, forKey: imageURL as NSString)
                DispatchQueue.main.async {
                    if self.urlString == imageURL {
                        self.image = img
                    }
                }
            }
        }
        task.resume()
    }
}
