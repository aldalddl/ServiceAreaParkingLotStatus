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
    static let typeList = [
        Car(type: .large, remainNumber: 0, totalNumber: 0),
        Car(type: .small, remainNumber: 0, totalNumber: 0),
        Car(type: .disabled, remainNumber: 0, totalNumber: 0)
    ]
    
    let type: CarType
    let remainNumber: Int?
    let totalNumber: Int?
}
