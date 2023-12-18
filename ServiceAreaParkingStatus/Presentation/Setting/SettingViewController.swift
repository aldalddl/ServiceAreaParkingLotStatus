//
//  SettingViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/09.
//

import Foundation
import UIKit
import SnapKit

class SettingViewController: UIViewController {
    let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .background
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "환경설정"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    func setup() {
        view.backgroundColor = .background
        
        navigationItem.titleView = titleLabel

        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
    func layout() {
        view.addSubview(settingTableView)
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.headerDescription else {
            return UITableViewHeaderFooterView()
        }
        
        let headerView = UIView()
        
        let headerLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .black
            label.text = description
            return label
        }()
        
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(20)
        }

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.footerDescription.description else {
            return UITableViewHeaderFooterView()
        }
        
        let footerView = UIView()
        
        let footerLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            label.textColor = .gray
            label.text = description
            return label
        }()
        
        footerView.addSubview(footerLabel)
        
        footerLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(18)
        }
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingSection(rawValue: section) else { return 0 }
        
        switch section {
        case .location:
            return Location.allCases.count
        case .information:
            return Information.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .location:
            return Location.allowLocation.cell
        case .information:
            return Information(rawValue: indexPath.row)?.cell ?? UITableViewCell()
        }
    }
}
