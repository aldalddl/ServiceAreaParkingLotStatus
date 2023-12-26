//
//  SettingToggleCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/18/23.
//

import Foundation
import UIKit
import SnapKit

class SettingToggleCell: UITableViewCell {
    lazy var toggleButton: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .primaryColor
        toggle.addTarget(self, action: #selector(switchToggleButton), for: .valueChanged)
        return toggle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .cellBGColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        self.addSubview(toggleButton)
        
        toggleButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchToggleButton(_ sender: UISwitch) {
        if sender.isOn {
            goToSetting()
        } else {
            goToSetting()
        }
    }
}

func goToSetting() {
    guard let bundleId = Bundle.main.bundleIdentifier else { return }
    
    guard let settingURL = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") else { return }
    
    if UIApplication.shared.canOpenURL(settingURL) {
        UIApplication.shared.open(settingURL) { (success) in
            print("Setting opened: \(success)")
        }
    }
}
