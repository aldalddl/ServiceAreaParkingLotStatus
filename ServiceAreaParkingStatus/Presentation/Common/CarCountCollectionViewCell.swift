//
//  CarCountTableViewCell.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/24.
//

import UIKit

class CarCountCollectionViewCell: UICollectionViewCell {
    let id = "CarCountCollectionViewCell"
    
    var carIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var carLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25)
        return label
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
        self.backgroundColor = .systemBackground
        self.layer.borderColor = UIColor.systemBackground.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    func layout() {
        self.addSubview(carIcon)
        self.addSubview(carLabel)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(80)
        }
        
        carIcon.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(10)
        }
        
        carLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(carIcon.snp.right).offset(10)
        }
    }
    
}
