//
//  ViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let searchBar = SearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        layout()
    }


    func setup() {
        self.view.addSubview(searchBar)
    }
    
    func layout() {
        searchBar.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
}

