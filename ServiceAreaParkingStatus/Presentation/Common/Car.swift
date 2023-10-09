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
}

extension Car {
    static var list = [
        Car(type: "대형", remainNumber: nil, totalNumber: nil),
        Car(type: "소형", remainNumber: nil, totalNumber: nil),
        Car(type: "장애인", remainNumber: nil, totalNumber: nil)
    ]
}
