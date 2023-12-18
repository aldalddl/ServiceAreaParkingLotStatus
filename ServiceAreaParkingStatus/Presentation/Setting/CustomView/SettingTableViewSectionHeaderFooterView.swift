//
//  SettingSectionHeaderFooterView.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/13/23.
//

import Foundation
import UIKit
import SnapKit

public func SettingTableViewSectionHeaderView(description: String) -> UIView {
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

public func SettingTableViewSectionFooterView(description: String) -> UIView {
    
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
