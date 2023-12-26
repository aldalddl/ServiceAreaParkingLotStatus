//
//  Constants.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/15/23.
//

import Foundation
import UIKit

struct DeveloperInfo {
    static let developerName = "Minji Kang"
    static let description = "https://github.com/aldalddl"
}

/// 앱 관련 정보
/// 현재 스토어 버전 등을 관리하는 구조체
struct AppInfoData {
    static let currentVersion: String = {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "Undefined" }
        return "\(version)"
    }()
}

struct AppSettingInfo {
    static let bundleId = Bundle.main.bundleIdentifier ?? ""
    static let locationSettingUrl = "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)"
}
