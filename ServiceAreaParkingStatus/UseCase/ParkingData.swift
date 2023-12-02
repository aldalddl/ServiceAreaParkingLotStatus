//
//  ParkingData.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/21.
//

import Foundation

struct ParkingData: Codable {
    let currentCount: Int
    let data: [ParkingModel]
    let matchCount, page, perPage, totalCount: Int
}

struct Parking: Codable {
    let 노선: String
    let 대형: Int
    let 본부: String
    let 소형, 장애인, 합계: Int
    let 휴게소명: String
    
    var numberOfCar: [Int] {
        return [self.대형, self.소형, self.장애인]
    }
}

struct ParkingModel: Codable {
    let line: String
    let center: String
    let serviceArea: String
    let large, small, disbled, total: Int
    
    var numberOfCar: [Int] {
        return [self.large, self.small, self.disbled]
    }
    
    enum CodingKeys: String, CodingKey {
        case line = "노선"
        case center = "본부"
        case total = "합계"
        case serviceArea = "휴게소명"
        case large = "대형"
        case small = "소형"
        case disbled = "장애인"
    }
}
