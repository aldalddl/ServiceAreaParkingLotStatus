//
//  SettingViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/09.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation
import MaterialComponents.MaterialBottomSheet

class SettingViewController: UIViewController {
    let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .backgroundColor
        tableView.register(SettingToggleCell.self, forCellReuseIdentifier: SettingToggleCell.id)
        tableView.register(SettingInfoCell.self, forCellReuseIdentifier: SettingInfoCell.id)
        tableView.register(SettingDisclosureCell.self, forCellReuseIdentifier: SettingDisclosureCell.id)
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "환경설정"
        return label
    }()
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.settingTableView.reloadData()
        }
    }

    func setup() {
        view.backgroundColor = .backgroundColor
        
        navigationItem.titleView = titleLabel

        settingTableView.delegate = self
        settingTableView.dataSource = self
                
        locationManager.delegate = self
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
    
    private func openButtomSheet() {
        let bottomViewController = DeveloperInfoViewController()
        let bottomSheet = MDCBottomSheetController(contentViewController: bottomViewController)
        bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: 300)
        present(bottomSheet, animated: true, completion: nil)
    }
}


// MARK: SettingTableView Delegate
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

// MARK: SettingTableView Datasource
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

            // MARK: authorizationStatus 에 따른 toggle switch on/off 세팅
            let authorizationStatus: CLAuthorizationStatus = locationManager.authorizationStatus
            
            switch authorizationStatus {
            case .notDetermined:
                print(".notDetermined")
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                cell.toggleButton.isOn = false
            case .denied, .restricted:
                print(".denied, .restricted")
                cell.toggleButton.isOn = false
            case .authorizedWhenInUse:
                print(".authorizedWhenInUse")
                locationManager.startUpdatingLocation()
                cell.toggleButton.isOn = true
            default:
                print("default")
            }
            
            cell.textLabel?.text = Location.allowLocation.description
            
            cell.switchCallback = { isOn in
                self.goToSetting()
            }
            
            return cell
        case .information:
            guard let informationRow = Information(rawValue: indexPath.row) else { return UITableViewCell() }
            switch informationRow {
            case .version:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingInfoCell", for: indexPath) as? SettingInfoCell else { return UITableViewCell() }
                cell.subLabel.text = AppInfoData.currentVersion
                cell.textLabel?.text = informationRow.description
                return cell
            case .developer:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingDisclosureCell", for: indexPath) as? SettingDisclosureCell else { return UITableViewCell() }
                cell.textLabel?.text = informationRow.description
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .information:
            if Information.init(rawValue: indexPath.row) == .developer {
                openButtomSheet()
            }
        case .location:
            print("location")
        }
    }
}

// MARK: CLLoCationManager Delegate
extension SettingViewController: CLLocationManagerDelegate {
}
