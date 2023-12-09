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
    var nearAreaStackView = LabelListStackView()
    var parkingStatusStackView = LabelListStackView()
    var pagingIndex = 0

    var parkingManager = ParkingManager()
    var parkingDataArray = [ParkingModel]()
    /// [휴게소명: 방면]
    var serviceAreaArray = [String: String]()
    /// UISearchController ResultsUpdating 에서 검색된 휴게소명을 담는 변수
    var filteredServiceAreaArray = [String]()
    
    var isFiltering: Bool {
        let searchViewController = self.navigationItem.searchController
        let isActive = searchViewController?.isActive ?? false
        let isSearchBarHasText = searchViewController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.text = "휴게소 주차 현황"
        return label
    }()
    
    let collectionViewItemSize = CGSize(width: 332, height: 170)
    let collectionViewItemSpacing = 13.0
    var collectionViewInsetX: CGFloat {
        (UIScreen.main.bounds.width - collectionViewItemSize.width) / 2.0
    }
    var collectionViewContentInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: collectionViewInsetX, bottom: 0, right: collectionViewInsetX)
    }
    lazy var nearAreaCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = collectionViewItemSpacing
        flowLayout.itemSize = collectionViewItemSize
        
        var view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.isScrollEnabled = true
        view.isPagingEnabled = false
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = false
        view.clipsToBounds = true
        view.contentInsetAdjustmentBehavior = .never
        view.decelerationRate = .fast
        view.backgroundColor = .background
        view.contentInset = collectionViewContentInset
        view.register(NearAreaCollectionViewCell.self, forCellWithReuseIdentifier: NearAreaCollectionViewCell.id)
        return view
    }()
    
    var parkingStatusTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        layout()
        searchControllerSetup()
        searchControllerLayout()
        parkingManagerSetup()
    }
    
    // MARK: Setup
    func setup() {
        self.view.backgroundColor = .background
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonClicked(_ :)))
        navigationItem.rightBarButtonItem?.tintColor = .secondary

        nearAreaCollectionView.delegate = self
        nearAreaCollectionView.dataSource = self
        
        nearAreaStackView.leftLabel.text = "내 근처 휴게소"
        nearAreaStackView.rightLabel.text = "더보기"
        
        parkingStatusStackView.leftLabel.text = "남은 주차 자릿수"
        
        parkingStatusTableView.register(ParkingStatusTableViewCell.self, forCellReuseIdentifier: ParkingStatusTableViewCell.id)
        parkingStatusTableView.delegate = self
        parkingStatusTableView.dataSource = self
        parkingStatusTableView.backgroundColor = .background
        parkingStatusTableView.contentInset.top = 8
        parkingStatusTableView.contentInset.bottom = 35
    }
    
    // MARK: Layout
    func layout() {
        navigationController?.additionalSafeAreaInsets.top = 20
        
        view.addSubview(nearAreaStackView)
        nearAreaStackView.addArrangedSubview(nearAreaCollectionView)

        view.addSubview(parkingStatusStackView)
        parkingStatusStackView.addArrangedSubview(parkingStatusTableView)
        
        nearAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(95)
            make.left.right.equalToSuperview()
        }
        
        nearAreaCollectionView.snp.makeConstraints { make in
            make.height.equalTo(collectionViewItemSize.height)
            make.top.equalTo(nearAreaStackView.labelStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }

        parkingStatusStackView.snp.makeConstraints { make in
            make.top.equalTo(nearAreaStackView.snp.bottom).offset(60)
            make.left.right.equalToSuperview()
        }
        
        parkingStatusTableView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.top.equalTo(parkingStatusStackView.labelStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
}

// MARK: UISearchController Setup, Layout
extension ViewController {
    func searchControllerSetup() {
        searchViewController = UISearchController(searchResultsController: searchResultsController)
        
        self.navigationItem.searchController = searchViewController
        
        let image = UIImage()
        searchViewController.searchBar.setSearchFieldBackgroundImage(image, for: .normal)
        searchViewController.searchBar.searchTextField.backgroundColor = .searchbarBGColor
        searchViewController.searchBar.placeholder = "휴게소 이름 입력"
        searchViewController.searchBar.tintColor = .primary
        searchViewController.searchResultsUpdater = self

        searchResultsController.tableView.delegate = self
    }
    
    func searchControllerLayout() {
        searchViewController.searchBar.searchTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.left.right.equalToSuperview().inset(20)
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
        self.parkingDataArray = parking.data
        self.searchResultsController.parkingDataArray = parking.data
        
        let serviceAreaNameArray = parking.data.map { $0.serviceArea }
        self.serviceAreaArray = changeServiceAreaNameFormat(serviceAreaNameArray: serviceAreaNameArray)
        
        DispatchQueue.main.async {
            self.searchResultsController.tableView.reloadData()
            self.parkingStatusTableView.reloadData()
            self.nearAreaCollectionView.reloadData()
        }
    }
    
    func parkingManagerSetup() {
        parkingManager.delegate = self
        parkingManager.fetchParking()
    }
    
    func changeServiceAreaNameFormat(serviceAreaNameArray: [String]) -> [String: String] {
        var changedServiceAreaName = [String: String]()
        
        for serviceAreaName in serviceAreaNameArray {
            if serviceAreaName.contains("(") {
                let nameWithLine = serviceAreaName.components(separatedBy: ["(", ")"])
                let name = nameWithLine[0]
                let line = nameWithLine[1]
                changedServiceAreaName[name] = line + " 방면"
            } else {
                changedServiceAreaName[serviceAreaName] = ""
            }
        }
        
        return changedServiceAreaName
    }
}

// MARK: UISearchController ResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            self.filteredServiceAreaArray = self.serviceAreaArray.values.filter { $0.contains(text) }
        }
        
        if let resultVC = searchController.searchResultsController as? SearchResultsController {
            resultVC.filteredServiceAreaArray = self.filteredServiceAreaArray
            resultVC.tableView.reloadData()
        }
    }
}

// MARK: UITableView Delegate, DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0

        if tableView == searchResultsController.tableView && isFiltering {
            count = self.searchResultsController.filteredServiceAreaArray.count
            return count
        } else if tableView == parkingStatusTableView {
            if parkingDataArray.isEmpty {
                return 0
            }
            count = self.parkingDataArray[self.pagingIndex].numberOfCar.count
            return count
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
        } else if tableView == parkingStatusTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ParkingStatusTableViewCell.id, for: indexPath) as? ParkingStatusTableViewCell else {
                return UITableViewCell()
            }
            
            cell.carIconImageView.image = UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            
            if let image = CarType.allCases[indexPath.row].image {
                cell.carIconImageView.image = image
            }
            
            if parkingDataArray.isEmpty {
                return UITableViewCell()
            }
            
            cell.carLabel.text = CarType.allCases[indexPath.row].name
            cell.numberOfCarLabel.text = String(parkingDataArray[self.pagingIndex].numberOfCar[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: UICollectionView DataSource, DelegateFlowLayout
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceAreaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearAreaCollectionViewCell.id, for: indexPath) as? NearAreaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // TODO: 샘플 데이터를 서버 데이터로 대체하는 작업 필요
        cell.profileImageView.image = UIImage(named: "샘플이미지")
        
        let index = self.serviceAreaArray.index(self.serviceAreaArray.startIndex, offsetBy: indexPath.row)
        cell.nameLabel.text = self.serviceAreaArray[index].key
        cell.highwaylineLabel.text = self.serviceAreaArray[index].value
        
        cell.lineTag.removeAllTags()
        cell.lineTag.addTags([self.parkingDataArray[indexPath.row].center, self.parkingDataArray[indexPath.row].line])
        
        // TODO: 샘플 데이터를 서버 데이터로 대체하는 작업 필요
        cell.locationLabel.text = "경기도 구리시 수도권 제1순환고속도로 32"

        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = collectionViewItemSize.width + collectionViewItemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        if pagingIndex != Int(index) {
            self.parkingStatusTableView.reloadData()
        }
        
        pagingIndex = Int(index)
    }
}
