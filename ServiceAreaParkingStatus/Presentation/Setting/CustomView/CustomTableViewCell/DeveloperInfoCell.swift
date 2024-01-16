//
//  DeveloperInfoCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 1/17/24.
//

import Foundation
import UIKit
import SnapKit

class DeveloperInfoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        guard let textLabel = self.textLabel else { return }

        self.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(45)
            make.centerY.equalToSuperview()
            make.right.equalTo(textLabel.snp.left).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
