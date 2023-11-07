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
    var parkingStatusStackView = LabelStackView()
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
        label.textColor = .black
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
        view.backgroundColor = .background
        view.register(NearAreaCollectionViewCell.self, forCellWithReuseIdentifier: "NearAreaCollectionViewCell")
        return view
    }()
    var parkingStatusTableView: UITableView = {
        let tableView = UITableView()
        return tableView
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
        self.view.backgroundColor = .background
        
        navigationController?.additionalSafeAreaInsets.top = 20
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonClicked(_ :)))
        navigationItem.rightBarButtonItem?.tintColor = .secondary

        nearAreaCollectionView.dataSource = self

        nearAreaStackView.leftLabel.text = "내 근처 휴게소"
        nearAreaStackView.rightLabel.text = "더보기"
        
        parkingStatusStackView.leftLabel.text = "남은 주차 대수"
        parkingStatusTableView.register(ParkingStatusTableViewCell.self, forCellReuseIdentifier: ParkingStatusTableViewCell.id)
        parkingStatusTableView.delegate = self
        parkingStatusTableView.dataSource = self
        parkingStatusTableView.backgroundColor = .background
    }
    
    // MARK: Layout
    func layout() {
        view.addSubview(nearAreaStackView)
        nearAreaStackView.addArrangedSubview(nearAreaCollectionView)
        
        view.addSubview(parkingStatusStackView)
        parkingStatusStackView.addSubview(parkingStatusTableView)
        
        nearAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        nearAreaCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.top.equalTo(nearAreaStackView.labelStackView.snp.bottom).offset(20)
        }
        
        parkingStatusStackView.snp.makeConstraints { make in
            make.top.equalTo(nearAreaStackView.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        parkingStatusTableView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.top.equalTo(parkingStatusStackView.labelStackView.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

// MARK: UISearchController Setup
extension ViewController {
    func searchControllerSetup() {
        searchViewController = UISearchController(searchResultsController: searchResultsController)
        
        self.navigationItem.searchController = searchViewController
    
        searchViewController.searchBar.searchTextField.backgroundColor = .searchbar
        searchViewController.searchBar.placeholder = "휴게소 이름 입력"
        searchViewController.searchBar.tintColor = .primary
        searchViewController.searchResultsUpdater = self

        searchResultsController.tableView.delegate = self
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

// MARK: searchResultsController's UITableView Delegate, DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        if tableView == searchResultsController.tableView && isFiltering {
            count = self.searchResultsController.filteredServiceAreaArray.count
        }
        
        if tableView == parkingStatusTableView {
            count = Car.list.count
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchResultsController.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NearAreaCollectionViewCell", for: indexPath)
            
            if isFiltering {
                cell.textLabel?.text = self.searchResultsController.filteredServiceAreaArray[indexPath.row]
            }
            
            return cell
        }
        
        if tableView == parkingStatusTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ParkingStatusTableViewCell.id, for: indexPath) as! ParkingStatusTableViewCell
            
            cell.carIconImageView.image = Car.list[indexPath.row].iconImageView.image
            cell.carLabel.text = Car.list[indexPath.row].type
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
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
