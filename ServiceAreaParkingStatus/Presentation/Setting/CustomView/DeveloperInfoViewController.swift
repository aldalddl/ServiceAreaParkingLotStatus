//
//  DeveloperInfoViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/21/23.
//

import Foundation
import UIKit

class DeveloperInfoViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 36)
        label.textColor = .black
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 14)
        label.textColor = .gray
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        layout()
    }
    
    func setup() {
        self.view.backgroundColor = .backgroundColor
        
        titleLabel.text = DeveloperInfo.developerName
        subtitleLabel.text = DeveloperInfo.description
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func layout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(tableView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension DeveloperInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DeveloperInfoSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "DeveloperInfoCell")
        guard let section = DeveloperInfoSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        cell.backgroundColor = .backgroundColor
        
        cell.textLabel?.text = section.nameLabel
        cell.detailTextLabel?.text = section.desctiptionLabel
        cell.imageView?.image = UIImage(named: section.iconImageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = DeveloperInfoSection(rawValue: indexPath.section) else { return }
        
        if section.rawValue != DeveloperInfoSection.allCases.count - 1 {
            if let url = URL(string: section.sourceString) {
                UIApplication.shared.open(url)
            }
        } else {
            UIPasteboard.general.string = section.sourceString
            
            if let pastedString = UIPasteboard.general.string {
                print(pastedString)
            }
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

extension DeveloperInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
