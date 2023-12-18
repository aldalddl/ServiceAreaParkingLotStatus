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
        toggle.onTintColor = .primary
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
    
    // TODO: 설정 앱 - 해당 앱 - 위치 권한 페이지로 이동하도록 구현
    @objc func switchToggleButton(_ sender: UISwitch) {
        if sender.isOn {
            print("위치 접근 허용")
        } else {
            print("위치 접근 거부")
        }
    }
}
