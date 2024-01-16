//
//  DeveloperInfoSection.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 1/16/24.
//

import Foundation
import UIKit

enum DeveloperInfoSection: Int, CaseIterable {
    case github, email
    
    var iconImageName: String {
        switch self {
        case .github:
            return "github"
        case .email:
            return "email"
        }
    }
    
    var nameLabel: String {
        switch self {
        case .github:
            return "GitHub"
        case .email:
            return "E-Mail"
        }
    }
    
    var desctiptionLabel: String {
        switch self {
        case .github:
            return "더 많은 정보는 GitHub에서 확인하세요"
        case .email:
            return "앱에 대한 문의 사항이 있다면 언제든 알려주세요"
        }
    }
    
    var sourceString: String {
        switch self {
        case .github:
            return "https://github.com/aldalddl"
        case .email:
            return "aldalddl2007@gmail.com"
        }
    }
}
