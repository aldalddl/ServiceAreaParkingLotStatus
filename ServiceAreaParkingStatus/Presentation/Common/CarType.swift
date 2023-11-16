//
//  Car.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/24.
//

import Foundation
import UIKit

enum CarType: CaseIterable {
    case large, small, disabled
    
    var name: String {
        switch self {
        case .large:
            return "대형"
        case .small:
            return "소형"
        case .disabled:
            return "장애인전용"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .large:
            return UIImage(systemName: "bus.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .small:
            return UIImage(systemName: "car.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        case .disabled:
            return UIImage(named: "carForDisabled")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
    
}

struct Car {
    let type: CarType
    let remainNumber: Int?
    let totalNumber: Int?
}
