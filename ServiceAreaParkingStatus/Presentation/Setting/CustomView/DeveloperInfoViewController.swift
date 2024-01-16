//
//  DeveloperInfoViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/21/23.
//

import Foundation
import UIKit

class DeveloperInfoViewController: UIViewController {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 36)
        label.textColor = .black
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 14)
        label.textColor = .gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        layout()
    }
    
    func setup() {
        self.view.backgroundColor = .backgroundColor
        
        titleLabel.text = DeveloperInfo.developerName
        subtitleLabel.text = DeveloperInfo.description
    }
    
    func layout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
            make.left.right.equalToSuperview()
        }
    }
}
