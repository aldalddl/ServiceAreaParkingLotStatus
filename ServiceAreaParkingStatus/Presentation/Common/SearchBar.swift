//
//  SearchBar.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import Foundation
import UIKit

class SearchBar: UISearchBar {
    override init(frame: CGRect) {
        super .init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .green
        self.placeholder = "휴게소 이름을 입력하세요"
    }

}
