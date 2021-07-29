//
//  SettingPageController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 30/07/21.
//

import UIKit

class SettingPageController: UIViewController {
    //MARK:- Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var dismissView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        let tapGus = UITapGestureRecognizer(target: self,
                                            action: #selector(dismissViewClicked))
        tapGus.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGus)
        view.alpha = 0.75
        return view
    }()
    
    var selectionCallBack: (() -> Void)?
    
    private var langTogger = false
    private var countryTogger = false
    
    //MARK:- View Methods
    override func viewDidLoad() {
        view.addSubview(tableView)
        view.addSubview(dismissView)
        
        view.backgroundColor = .clear
        
        setUpConstraints()
        setUpTableView()
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            dismissView.topAnchor.constraint(equalTo: view.topAnchor),
            dismissView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dismissView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissView.leadingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
    
    private func setUpTableView() {
        tableView.register(SettingItemView.self, forCellReuseIdentifier: SettingItemView.IDENTIFIER)
        tableView.register(SettingItemHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingItemHeaderView.IDENTIFIER)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK:- OBJC Methods
    @objc
    func dismissViewClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func itemTapped(sender: UITapGestureRecognizer) {
        let loc = sender.location(in: tableView)
        
        if let sec = tableView.headerView(forSection: 0),
           sec.frame.contains(loc) {
            self.langTogger.toggle()
        } else if let sec = tableView.headerView(forSection: 1),
                  sec.frame.contains(loc) {
            self.countryTogger.toggle()
        }
        self.tableView.reloadData()
    }
}

//MARK:- TableView Methods
extension SettingPageController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && langTogger {
            return Languages.allCases.count + 1
        }
        if section == 1 && countryTogger {
            return Countries.allCases.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemView.IDENTIFIER, for: indexPath) as! SettingItemView
        switch indexPath.section {
        case 0:
            if indexPath.row > 0,
               UserDefaultsData.language == Languages.allCases[indexPath.row - 1].rawValue {
                cell.imgView.image = UIImage(systemName: "checkmark.square.fill")
            } else {
                cell.imgView.image = UIImage(systemName: "checkmark.square")
            }
            if indexPath.row == 0 {
                cell.title.text = "All Languages"
                if UserDefaultsData.language.isEmpty {
                    cell.imgView.image = UIImage(systemName: "checkmark.square.fill")
                }
            } else {
                cell.title.text = Languages.allCases[indexPath.row - 1].fullName
            }
        case 1:
            if indexPath.row > 0,
               UserDefaultsData.country == Countries.allCases[indexPath.row - 1].rawValue {
                cell.imgView.image = UIImage(systemName: "checkmark.square.fill")
            } else {
                cell.imgView.image = UIImage(systemName: "checkmark.square")
            }
            if indexPath.row == 0 {
                cell.title.text = "All Countries"
                if UserDefaultsData.country.isEmpty {
                    cell.imgView.image = UIImage(systemName: "checkmark.square.fill")
                }
            } else {
                cell.title.text = Countries.allCases[indexPath.row - 1].fullName
            }
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UserDefaultsData.language = ""
            } else {
                UserDefaultsData.language = Languages.allCases[indexPath.row - 1].rawValue
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                UserDefaultsData.country = ""
            } else {
                UserDefaultsData.country = Countries.allCases[indexPath.row - 1].rawValue
            }
        }
        tableView.reloadData()
        selectionCallBack?()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SettingItemHeaderView()
        view.title.text = section == 0 ? "Language" : "Country"
        if (section == 0 && langTogger) ||
            (section == 1 && countryTogger) {
            view.imgView.transform  = CGAffineTransform(rotationAngle: .pi)
        }
        
        let tapGus = UITapGestureRecognizer(target: self,
                                            action: #selector(itemTapped))
        tapGus.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGus)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
