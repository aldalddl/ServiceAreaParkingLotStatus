//
//  ServiceAreaCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/10.
//

import Foundation
import UIKit
import SnapKit

class NearAreaCollectionViewCell: UICollectionViewCell {
    static let id = "NearAreaCollectionViewCell"
    
    var profileImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        label.backgroundColor = .systemBlue
        return label
    }()
    
    var highwaylineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray5
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        label.backgroundColor = .systemPink
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    var profileLabelStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 5
        view.axis = .vertical
//        view.backgroundColor = .systemGreen
        return view
    }()
    
    var profileStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 15.0
        view.axis = .horizontal
        return view
    }()
    
    var totalStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10.0
        view.axis = .vertical
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.backgroundColor = .systemGray
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
        
        profileLabelStackView.addArrangedSubview(nameLabel)
        profileLabelStackView.addArrangedSubview(highwaylineLabel)
        
        profileStackView.addArrangedSubview(profileImageView)
        profileStackView.addArrangedSubview(profileLabelStackView)
        
        totalStackView.addArrangedSubview(profileStackView)
        totalStackView.addArrangedSubview(locationLabel)
        
        self.contentView.addSubview(totalStackView)
    }
    
    func layout() {
        totalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.height.equalTo(totalStackView.snp.height).multipliedBy(0.4)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(totalStackView.snp.width).multipliedBy(0.4).priority(.init(999))
            make.width.equalTo(profileImageView.snp.height).multipliedBy(1.0/1.0).priority(.init(1000))
        }
    }
}
