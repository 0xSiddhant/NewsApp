//
//  SourceItemView.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 26/07/21.
//

import UIKit
import SwiftUI

class SourceItemView: UITableViewCell {
    
    //MARK:- Properites
    static let IDENTIFIER = SourceItemView.description()
    
    lazy var title: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 18)
        txtview.adjustsFontForContentSizeCategory = true
        txtview.textColor = .label
        txtview.numberOfLines = 2
        return txtview
    }()
    
    
    //MARK:- Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        
        setUpConstraint()
    }
    
    /// Set Up the Constraint of containing views
    func setUpConstraint()  {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -44),
            
        ])
    }
    
    func populateData(source: Source) {
        title.text = source.name
    }
}

struct SourceItemViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SourceItemView {
        return SourceItemView()
    }
    
    func updateUIView(_ uiView: SourceItemView, context: Context) { }
}

struct SourceItem_Preview: PreviewProvider {
    static var previews: some View {
        SourceItemViewRepresentable()
    }
}
