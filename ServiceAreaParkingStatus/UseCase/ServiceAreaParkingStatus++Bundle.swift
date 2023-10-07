//
//  ServiceAreaParkingStatus++Bundle.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "ParkingInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("ParkingInfo.plist에 API_KEY 설정") }
        
        return key
    }
}
