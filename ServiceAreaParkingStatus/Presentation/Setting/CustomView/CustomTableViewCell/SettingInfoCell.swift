//
//  SettingInfoCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/18/23.
//

import Foundation
import UIKit
import SnapKit

class SettingInfoCell: UITableViewCell {
    var subLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .cellBGColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.textLabel?.textColor = .gray
        
        self.contentView.addSubview(subLabel)
        
        subLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
