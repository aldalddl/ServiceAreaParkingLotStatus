//
//  Car.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/24.
//

import Foundation
import UIKit

enum Car {
    case large
    case small
    case disabled

    var icon: UIImageView {
        switch self {
        case .large:
            return UIImageView(image: UIImage(named: "largeCar"))
        case .small:
            return UIImageView(image: UIImage(named: "smallCar"))
        case .disabled:
            return UIImageView(image: UIImage(named: "disabledCar"))
        }
    }

    var name: String {
        switch self {
        case .large:
            return "대형"
        case .small:
            return "소형"
        case .disabled:
            return "장애인"
        }
    }
}

