//
//  SettingDisclosureCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/18/23.
//

import Foundation
import UIKit

class SettingDisclosureCell: UITableViewCell {
    static let id = "SettingDisclosureCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .cellBGColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
