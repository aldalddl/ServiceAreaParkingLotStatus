//
//  DeveloperInfoViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/21/23.
//

import Foundation
import UIKit

class DeveloperInfoViewController: UIViewController {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        layout()
    }
    
    func setup() {
        self.view.backgroundColor = .systemBlue
        
        nameLabel.text = DeveloperInfo.developerName
        descriptionLabel.text = DeveloperInfo.description
    }
    
    func layout() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(descriptionLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }
    }
}
