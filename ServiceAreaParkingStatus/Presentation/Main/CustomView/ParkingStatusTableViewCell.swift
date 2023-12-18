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
    
    var carIconImageView = UIImageView()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var numberOfCarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    func setup() {
        self.backgroundColor = .backgroundColor
        self.contentView.backgroundColor = .backgroundColor
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.shadowColor = UIColor.systemGray.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowRadius = 15
        self.contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func layout() {
        self.contentView.addSubview(carIconImageView)
        self.contentView.addSubview(carLabel)
        self.contentView.addSubview(numberOfCarLabel)

        carIconImageView.snp.makeConstraints { make in
            make.size.equalTo(27)
            make.left.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        
        carLabel.snp.makeConstraints { make in
            make.left.equalTo(carIconImageView.snp.right).offset(20)
            make.centerY.equalToSuperview()
        }
        
        numberOfCarLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
    }
}
