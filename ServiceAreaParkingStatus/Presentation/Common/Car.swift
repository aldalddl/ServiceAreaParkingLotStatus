//
//  Car.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/24.
//

import Foundation
import UIKit

struct Car {
    let type: String
    let remainNumber: Int?
    let totalNumber: Int?
    let iconImageView: UIImageView
}

extension Car {
    static var list = [
        Car(type: "대형", remainNumber: nil, totalNumber: nil, iconImageView: UIImageView(image: UIImage(named: "대형"))),
        Car(type: "소형", remainNumber: nil, totalNumber: nil, iconImageView: UIImageView(image: UIImage(named: "소형"))),
        Car(type: "장애인 전용", remainNumber: nil, totalNumber: nil, iconImageView: UIImageView(image: UIImage(named: "장애인")))
    ]
}
