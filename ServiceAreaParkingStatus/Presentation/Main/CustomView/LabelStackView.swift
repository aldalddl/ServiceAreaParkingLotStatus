//
//  ViewBlockWithLabel.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/12.
//

import Foundation
import UIKit

class LabelStackView: UIStackView {
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    var labelStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .horizontal
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    func setup() {
        self.backgroundColor = .background
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 20
        self.axis = .vertical
    }
    
    // MARK: Layout
    func layout() {
        self.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(leftLabel)
        labelStackView.addArrangedSubview(rightLabel)
    }
}
