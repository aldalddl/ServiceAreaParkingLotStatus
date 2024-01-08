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
        tableView.backgroundColor = .backgroundColor
        tableView.register(SettingToggleCell.self, forCellReuseIdentifier: "SettingToggleCell")
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
        view.backgroundColor = .backgroundColor
        
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
    
    private func goToSetting() {
        guard let settingURL = URL(string: AppSettingInfo.locationSettingUrl) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL) { (success) in
                print("Setting opened: \(success)")
            }
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.headerDescription else {
            return UITableViewHeaderFooterView()
        }
        
        return SettingTableViewSectionHeaderView(description: description)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let description = SettingSection(rawValue: section)?.footerDescription.description else {
            return UITableViewHeaderFooterView()
        }
 
        return SettingTableViewSectionFooterView(description: description)
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingToggleCell", for: indexPath) as? SettingToggleCell else {
                return UITableViewCell()
            }
            cell.switchCallback = { isOn in
                self.goToSetting()
            }
            
            return cell
        case .information:
            return Information(rawValue: indexPath.row)?.cell ?? UITableViewCell()
        }
    }
}
