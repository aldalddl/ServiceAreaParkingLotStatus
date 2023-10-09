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
        
//        carIcon.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 0.6326572848)
//        carLabel.backgroundColor = #colorLiteral(red: 0.9272031784, green: 0.8204885125, blue: 0.5319427252, alpha: 0.8028249172)
        self.addSubview(carIcon)
        self.addSubview(carLabel)
    }
    
    func layout() {
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
