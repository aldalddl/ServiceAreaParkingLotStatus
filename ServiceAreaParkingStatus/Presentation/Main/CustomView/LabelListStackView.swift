//
//  LabelListStackView.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/12.
//

import Foundation
import UIKit

class LabelListStackView: UIStackView {
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
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
        
        setUp()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp
    func setUp() {
        self.backgroundColor = .systemBackground
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 20
        self.axis = .vertical
    }
    
    // MARK: Layout
    func layout() {
        self.addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(leftLabel)
        labelStackView.addArrangedSubview(rightLabel)
        
        labelStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(31)
        }
    }
}
