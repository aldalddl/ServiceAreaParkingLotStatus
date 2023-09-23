//
//  ParkingData.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/21.
//

import Foundation

struct ParkingData: Codable {
    let currentCount: Int
    let data: [Parking]
    let matchCount, page, perPage, totalCount: Int
}

struct Parking: Codable {
    let 노선: 노선
    let 대형: Int
    let 본부: 본부
    let 소형, 장애인, 합계: Int
    let 휴게소명: String
}

enum 노선: String, Codable {
    case 경부선 = "경부선"
    case 서해안선 = "서해안선"
    case 수도권제1순환선 = "수도권제1순환선"
}

enum 본부: String, Codable {
    case 수도권 = "수도권"
}
