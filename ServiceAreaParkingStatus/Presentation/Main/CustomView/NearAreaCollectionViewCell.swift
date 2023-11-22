//
//  NearAreaCollectionViewCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/10.
//

import Foundation
import UIKit
import SnapKit
import TagListView

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
    
    var lineTag: TagListView = {
        let tag = TagListView()
        tag.alignment = .left
        tag.textFont = UIFont.systemFont(ofSize: 12, weight: .regular)
        tag.textColor = .white
        tag.tagBackgroundColor = .tagListColor ?? .systemBlue
        tag.cornerRadius = 15
        tag.shadowColor = .systemGray
        tag.shadowOpacity = 0.2
        tag.shadowRadius = 15
        tag.shadowOffset = CGSize(width: 5, height: 5)
        tag.paddingX = 14
        tag.paddingY = 8
        tag.marginX = 10
        return tag
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
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 15.0
        return view
    }()
    
    var totalStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10.0
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
        totalStackView.addArrangedSubview(lineTag)
        totalStackView.addArrangedSubview(locationLabel)
        
        self.contentView.addSubview(totalStackView)
        
        totalStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(profileImageLabelStackView.snp.width).multipliedBy(0.4)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
}
