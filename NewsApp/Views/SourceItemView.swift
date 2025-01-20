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
    var viewModel: SourceViewModel!
    
    lazy var title: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 18)
        txtview.adjustsFontForContentSizeCategory = true
        txtview.textColor = .label
        txtview.numberOfLines = 2
        return txtview
    }()
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(systemName: "chevron.down.square.fill")
        return imgView
    }()
    
    lazy var descriptionLbl: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 16)
        txtview.textColor = .secondaryLabel
        txtview.textAlignment = .justified
        txtview.numberOfLines = 0
        return txtview
    }()
    
    lazy var categoryLbl: UILabel = {
        let txtview = UILabel()
        txtview.translatesAutoresizingMaskIntoConstraints = false
        txtview.font = UIFont.boldSystemFont(ofSize: 14)
        txtview.textColor = .tertiaryLabel
        return txtview
    }()
    
    lazy var vStackView: UIStackView = {
        var sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()
    
    lazy var visitBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(systemName: "globe"), for: .normal)
        btn.addTarget(self, action: #selector(visitBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var searchBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        btn.addTarget(self, action: #selector(searchBtnClicked), for: .touchUpInside)
        return btn
    }()
    
    lazy var hStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    lazy var bottomConstraint = contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: 8)
    
    //MARK:- Initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(imgView)
        
        hStackView.addArrangedSubview(categoryLbl)
        hStackView.addArrangedSubview(visitBtn)
        hStackView.addArrangedSubview(searchBtn)
        
        hStackView.setCustomSpacing(12, after: visitBtn)
        
        vStackView.addArrangedSubview(descriptionLbl)
        vStackView.addArrangedSubview(hStackView)
        
        setUpConstraint()
    }
    
    //MARK:- Methods
    /// Set Up the Constraint of containing views
    func setUpConstraint()  {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: 8),
            bottomConstraint,
            
            imgView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
            imgView.heightAnchor.constraint(equalToConstant: 30),
            
            visitBtn.widthAnchor.constraint(equalToConstant: 25),
            visitBtn.heightAnchor.constraint(equalTo: visitBtn.widthAnchor),
            
            searchBtn.widthAnchor.constraint(equalToConstant: 25),
            searchBtn.heightAnchor.constraint(equalTo: searchBtn.widthAnchor),
            
        ])
    }
    
    func setUpStackView(addStackView: Bool) {
        //FIXME:- Constraint Break Issue At Toggeling UIStackView
        if addStackView {
            contentView.addSubview(vStackView)
            NSLayoutConstraint.activate([
                vStackView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
                vStackView.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                vStackView.trailingAnchor.constraint(equalTo: imgView.trailingAnchor),
                vStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ])
            imgView.transform = CGAffineTransform(rotationAngle: .pi)
            bottomConstraint.priority = UILayoutPriority(250)
        } else {
            vStackView.removeFromSuperview()
            bottomConstraint.priority = UILayoutPriority(1000)
            imgView.transform = CGAffineTransform(rotationAngle: .pi * 2)
        }
    }
    
    func populateData(source: Source) {
        title.text = source.name
        descriptionLbl.text = source.description
        categoryLbl.text = "Category: \(source.category)"
    }
    
    //MARK:- Objc Methods
    @objc
    func visitBtnClicked() {
        viewModel.openSelectedNewsLink(of: tag)
    }
    
    @objc
    func searchBtnClicked() {
        viewModel.setSourceID(of: tag)
    }
}

//MARK:- SwiftUI Preview
struct SourceItemViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> SourceItemView {
        let ui = SourceItemView()
        ui.setUpStackView(addStackView: true)
        return ui
    }
    
    func updateUIView(_ uiView: SourceItemView, context: Context) { }
}

struct SourceItem_Preview: PreviewProvider {
    static var previews: some View {
        SourceItemViewRepresentable()
            .frame(width: 300, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
