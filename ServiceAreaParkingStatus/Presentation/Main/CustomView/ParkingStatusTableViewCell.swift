//
//  ParkingStatusTableViewCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/11/07.
//

import Foundation
import UIKit
import SnapKit

class ParkingStatusTableViewCell: UITableViewCell {
    static let id = "ParkingStatusTableViewCell"
    
    var carIconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.backgroundColor = .background
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.shadowColor = UIColor.systemGray.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowRadius = 15
        self.contentView.layer.shadowOffset = CGSize(width: 10, height: 10)
    }
    
    func layout() {
        self.contentView.addSubview(carIconImageView)
        self.contentView.addSubview(carLabel)

        carIconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.left.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        carLabel.snp.makeConstraints { make in
            make.left.equalTo(carIconImageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
    }
}
