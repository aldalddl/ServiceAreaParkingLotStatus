//
//  Constants.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/15/23.
//

import Foundation

struct AppInfoData {
    static let currentVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "Undefined" }
        return "\(version)"
    }()
}
