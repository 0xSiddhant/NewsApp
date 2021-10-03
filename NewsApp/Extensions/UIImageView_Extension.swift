//
//  UIImageView_Extension.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 03/10/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with url: String?) {
        guard let imgURL = url else {
            image = UIImage(systemName: "newspaper.fill")
            return
        }
        setImage(with: URL(string: imgURL))
    }
    
    func setImage(with url: URL?) {
        guard let url = url else {
            image = UIImage(systemName: "newspaper.fill")
            return
        }
        let processor = DownsamplingImageProcessor(size: frame.size)
        
        kf.indicatorType = .activity
        kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "newspaper.fill"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            #if DEBUG
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
            #endif
        }
    }
}
