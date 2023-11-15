//
//  NearAreaCollectionViewCell.swift
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
        return label
    }()
    
    var highwaylineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray5
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    var labelStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    var profileImageLabelStackView: UIStackView = {
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
    
    // MARK: Setup
    func setup() {
        self.contentView.backgroundColor = .primary
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 15
    }
    
    // MARK: Layout
    func layout() {
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(highwaylineLabel)
        
        profileImageLabelStackView.addArrangedSubview(profileImageView)
        profileImageLabelStackView.addArrangedSubview(labelStackView)
        
        totalStackView.addArrangedSubview(profileImageLabelStackView)
        totalStackView.addArrangedSubview(locationLabel)
        
        self.contentView.addSubview(totalStackView)
        
        totalStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(20)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.height.equalTo(totalStackView.snp.height).multipliedBy(0.3)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(profileImageLabelStackView.snp.width).multipliedBy(0.4)
        }
    }
}
