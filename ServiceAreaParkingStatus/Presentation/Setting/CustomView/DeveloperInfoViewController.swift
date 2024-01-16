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
        tableView.register(DeveloperInfoCell.self, forCellReuseIdentifier: "DeveloperInfoCell")
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    /// Toast Message 생성 메서드
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: Int(self.view.frame.size.width)/2 - 75, y: Int(self.view.frame.size.height) - 100, width: 150, height: 35))
        
        toastLabel.backgroundColor = .black.withAlphaComponent(0.6)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.adjustsFontSizeToFitWidth = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (_) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension DeveloperInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DeveloperInfoRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeveloperInfoCell", for: indexPath) as? DeveloperInfoCell else { return UITableViewCell() }
        
        guard let section = DeveloperInfoRows(rawValue: indexPath.row) else { return UITableViewCell() }
        
        cell.backgroundColor = .backgroundColor
        
        cell.textLabel?.text = section.nameLabel
        cell.detailTextLabel?.text = section.desctiptionLabel
        cell.imageView?.image = UIImage(named: section.iconImageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = DeveloperInfoRows(rawValue: indexPath.row) else { return }
        
        if section.rawValue != DeveloperInfoRows.allCases.count - 1 {
            if let url = URL(string: section.sourceString) {
                UIApplication.shared.open(url)
            }
        } else {
            UIPasteboard.general.string = section.sourceString
            showToast(message: " 이메일 주소가 복사되었습니다 ")
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

extension DeveloperInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
