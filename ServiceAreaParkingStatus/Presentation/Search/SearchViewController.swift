//
//  SearchViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/09.
//

import Foundation
import UIKit
import SnapKit

class SearchViewController: UIViewController {
    var carCountArray = [Int]()
    var highwayLine = String()
    var highwayCenter = String()
    var highwayLineLabel = UILabel()
    var highwayCenterLabel = UILabel()
    var collectionView: UICollectionView = {
        let layout = CarCountCollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = .zero
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        return view
    }()
    var collectionViewCell = CarCountCollectionViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetup()
        collectionViewLayout()
        setup()
        layout()
    }
    
    func collectionViewSetup() {
        collectionView.register(CarCountCollectionViewCell.self, forCellWithReuseIdentifier: "CarCountCollectionViewCell")
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    
    func setup() {
        self.view.backgroundColor = .systemBackground
        highwayLineLabel.text = "노선: " + highwayLine
        highwayCenterLabel.text = "본부: " + highwayCenter
        self.view.addSubview(highwayLineLabel)
        self.view.addSubview(highwayCenterLabel)
    }
    
    func layout() {
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        highwayLineLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(50)
        }
        
        highwayCenterLabel.snp.makeConstraints { make in
            make.top.equalTo(highwayLineLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(50)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCell.id, for: indexPath) as! CarCountCollectionViewCell
        
        let carType = Car.list[indexPath.row].type
        cell.carIcon.image = UIImage(named: carType)
        cell.carLabel.text = carType + ": \(carCountArray[indexPath.row])"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let height = (collectionView.frame.height - 60) / 3

        return CGSize(width: width, height: height)
    }
    
}
