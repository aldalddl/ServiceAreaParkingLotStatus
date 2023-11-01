//
//  ViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var searchResultsController = SearchResultsController()
    var searchViewController = UISearchController()
    var parkingManager = ParkingManager()
    var nearAreaStackView = LabelStackView()
    var serviceAreaArray = [String]()
    var filteredServiceAreaArray = [String]()
    var parkingLotArray = [Parking]()
    var isFiltering: Bool {
        let searchViewController = self.navigationItem.searchController
        let isActive = searchViewController?.isActive ?? false
        let isSearchBarHasText = searchViewController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "휴게소 주차 현황"
        return label
    }()
    var nearAreaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.0
        layout.itemSize = CGSize(width: 250, height: 150)
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .zero
        view.register(NearAreaCollectionViewCell.self, forCellWithReuseIdentifier: "NearAreaCollectionViewCell")
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        searchControllerSetup()
        parkingManagerSetup()
    }
    
    // MARK: Setup
    func setup() {
        self.view.backgroundColor = .systemBackground
        
        searchViewController = UISearchController(searchResultsController: searchResultsController)
        searchResultsController.tableView.delegate = self

        nearAreaCollectionView.dataSource = self
        
        nearAreaStackView.leftLabel.text = "내 근처 휴게소"
        nearAreaStackView.rightLabel.text = "더보기"
    }
    
    func searchControllerSetup() {
        self.navigationItem.searchController = searchViewController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonClicked(_ :)))
        
        searchViewController.searchBar.placeholder = "휴게소 이름 입력"
        searchViewController.searchResultsUpdater = self
    }
    
    // MARK: Layout
    func layout() {
        view.addSubview(nearAreaStackView)
        nearAreaStackView.addArrangedSubview(nearAreaCollectionView)
        
        nearAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        nearAreaCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
}

// MARK: Button Action
extension ViewController {
    @objc func settingButtonClicked(_ sender: UIBarButtonItem) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: API Response
extension ViewController: ParkingManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateParking(_ parkingManager: ParkingManager, parking: ParkingData) {
        self.serviceAreaArray = parking.data.map{ String($0.휴게소명) }
        self.parkingLotArray = parking.data
        self.searchResultsController.parkingLotArray = parking.data
        
        DispatchQueue.main.async {
            self.searchResultsController.tableView.reloadData()
            self.nearAreaCollectionView.reloadData()
        }
    }
    
    func parkingManagerSetup() {
        parkingManager.delegate = self
        parkingManager.fetchParking()
    }
}


// MARK: UISearchController ResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            self.filteredServiceAreaArray = self.serviceAreaArray.filter{ $0.contains(text) }
        }
        
        if let resultVC = searchController.searchResultsController as? SearchResultsController {
            resultVC.filteredServiceAreaArray = self.filteredServiceAreaArray
            resultVC.tableView.reloadData()
        }
    }
}

// MARK: searchResultsController's UITableView Delegate 
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        if tableView == searchResultsController.tableView {
            if isFiltering {
                count = self.searchResultsController.filteredServiceAreaArray.count
            }
        }
        
        return count
    }

    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "NearAreaCollectionViewCell", for: indexPath)
        
        if isFiltering {
            cell.textLabel?.text = self.searchResultsController.filteredServiceAreaArray[indexPath.row]
        }
        
        return cell

    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceAreaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearAreaCollectionViewCell.id, for: indexPath) as! NearAreaCollectionViewCell
        
        cell.profileImageView.image = UIImage(named: "샘플이미지")
        cell.nameLabel.text = self.serviceAreaArray[indexPath.row]
        cell.highwaylineLabel.text = self.parkingLotArray[indexPath.row].노선.rawValue
        cell.locationLabel.text = "경기도 구리시 수도권 제1순환고속도로 32"
        
        return cell
    }
}
