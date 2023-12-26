//
//  SettingSection.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 12/7/23.
//

import Foundation
import UIKit

enum SettingSection: Int, CaseIterable {
    case location, information
    
    var headerDescription: String {
        switch self {
        case .location:
            return "위치"
        case .information:
            return "정보"
        }
    }
    
    var footerDescription: String {
        switch self {
        case .location:
            return "현재 위치와 가까운 휴게소를 확인하기 위해 접근 허용이 필요합니다"
        case .information:
            return "앱 정보를 표시합니다"
        }
    }
}

enum Location: Int, CaseIterable {
    case allowLocation
    
    var description: String {
        switch self {
        case .allowLocation:
            return "위치 접근 허용"
        }
    }
    
    var cell: UITableViewCell {
        switch self {
        case .allowLocation:
            let cell = SettingToggleCell()
            cell.textLabel?.text = self.description
            return cell
        }
    }
}

enum Information: Int, CaseIterable {
    case version, developer
    
    var description: String {
        switch self {
        case .version:
            return "버전"
        case .developer:
            return "개발자 정보"
        }
    }
    
    var cell: UITableViewCell {
        switch self {
        case .version:
            let cell = SettingInfoCell()
            cell.textLabel?.text = self.description
            cell.subLabel.text = AppInfoData.currentVersion
            return cell
        case .developer:
            let cell = SettingDisclosureCell()
            cell.textLabel?.text = self.description
            return cell
        }
    }
}
