//
//  SettingItemHeaderview.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 30/07/21.
//

import UIKit

class SettingItemHeaderView: UITableViewHeaderFooterView {
    
    static let IDENTIFIER = SettingItemHeaderView.description()
    
    lazy var title: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 18)
        txtview.adjustsFontForContentSizeCategory = true
        txtview.textColor = .secondaryLabel
        txtview.numberOfLines = 1
        return txtview
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "chevron.down.square.fill")
        return imgView
    }()
    
    init() {
        super.init(reuseIdentifier: SettingItemHeaderView.IDENTIFIER)
        addSubview(title)
        addSubview(imgView)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            
            imgView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 30),
            imgView.leadingAnchor.constraint(equalTo: title.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not meant for storyboard")
    }
}
