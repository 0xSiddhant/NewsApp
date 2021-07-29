//
//  SettingItemView.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 30/07/21.
//

import UIKit

class SettingItemView: UITableViewCell {
    
    //MARK:- Properties
    static let IDENTIFIER = SettingItemView.description()
    
    lazy var title: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 16)
        txtview.adjustsFontForContentSizeCategory = true
        txtview.textColor = .label
        return txtview
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    //MARK:- Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(imgView)
        
        NSLayoutConstraint.activate([
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            
            imgView.widthAnchor.constraint(equalToConstant: 35),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imgView.trailingAnchor.constraint(equalTo: title.leadingAnchor, constant:  -8),
            imgView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
