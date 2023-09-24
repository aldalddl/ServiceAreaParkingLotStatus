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
    let icon: UIImageView
}

extension Car {
    static var list = [
        Car(type: "대형", icon: UIImageView(image: UIImage(named: "largeCar"))),
        Car(type: "소형", icon: UIImageView(image: UIImage(named: "smallCar"))),
        Car(type: "장애인", icon: UIImageView(image: UIImage(named: "disabledCar")))
    ]
}
