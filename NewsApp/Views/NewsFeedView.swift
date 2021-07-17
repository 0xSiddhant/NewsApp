//
//  NewsFeedView.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import SwiftUI
import UIKit

final class NewsFeedView: UITableViewCell {
    
    //MARK:- Properties
    static let IDENTIFIER = NewsFeedView.description()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    lazy var title: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 18)
        txtview.adjustsFontForContentSizeCategory = true
        txtview.textColor = .label
        return txtview
    }()
    
    lazy var descLabel: UILabel = {
        let desc = UILabel()
        desc.numberOfLines = 0
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = UIFont.systemFont(ofSize: 16)
        desc.textColor = .secondaryLabel
        desc.textAlignment = .justified
        desc.adjustsFontSizeToFitWidth = true
        return desc
    }()
    
    lazy var publishLabel: UILabel = {
        let pub = UILabel()
        pub.textColor = .secondaryLabel
        pub.font = UIFont.systemFont(ofSize: 15)
        pub.translatesAutoresizingMaskIntoConstraints = false
        return pub
    }()
    
    lazy var author: UILabel = {
        let author = UILabel()
        author.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .medium)
        author.translatesAutoresizingMaskIntoConstraints = false
        author.textColor = .tertiaryLabel
        return author
    }()
    
    //MARK:- Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imgView)
        contentView.addSubview(title)
        contentView.addSubview(descLabel)
        contentView.addSubview(publishLabel)
        contentView.addSubview(author)
        
        setUpConstraint()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not ment for storyboard")
    }
    
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: 0.5),
        
            publishLabel.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -1),
            publishLabel.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -4),
            
            title.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: 4),
            title.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -4),
            
            descLabel.topAnchor.constraint(equalTo: title.bottomAnchor),
            descLabel.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            
            author.topAnchor.constraint(equalTo: descLabel.bottomAnchor),
            author.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            author.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func populateCell(article: Article) {
        title.text = article.title
        descLabel.text = article.description
        publishLabel.text = article.publishedAt
        imgView.backgroundColor = .systemTeal
        author.text = article.author
    }
}

//MARK:- SwiftUI Preview
struct NewsFeedRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> NewsFeedView {
        let article = Article(source: Article.Source(name: "", id: ""), author: "Urmimala Banerjee", title: "Article Test", description: "Salman Khan's close friend Ashley Rebello wished Katrina Kaif in this manner. This has sparked off many rumours", url: "", urlToImage: "", publishedAt: "2021-07-17T04:51:01Z", content: "")
        let view = NewsFeedView()
        view.populateCell(article: article)
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


struct NewsFeed_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            NewsFeedRepresentable()
                .frame(width: 310, height: 270)
        }
            
    }
}
