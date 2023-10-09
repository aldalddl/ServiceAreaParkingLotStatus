//
//  GridCollectionViewFlowLayout.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/25.
//

import Foundation
import UIKit

class CarCountCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var numberOfColumns = 1
    var cellSpacing = 20.0
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
        self.minimumLineSpacing = cellSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
