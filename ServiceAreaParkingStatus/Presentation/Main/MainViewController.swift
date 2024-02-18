//
//  ViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    var apiManager = APIManager()
    var serviceAreaTotalInfoList = [ParkingModel]()
    var serviceAreaNameList = [ServiceAreaName]()
    var filteredServiceAreaNameList = [ServiceAreaName]()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "휴게소 주차 현황"
        return label
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "휴게소 이름 입력"
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.backgroundImage = UIImage(named: "whiteColor")
        searchBar.backgroundColor = .backgroundColor
        searchBar.tintColor = .primaryColor

        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.backgroundColor = .searchbarBGColor
        
        return searchBar
    }()
    
    let nearAreaStackView: LabelListStackView = {
        let stackView = LabelListStackView()
        stackView.leftLabel.text = "내 근처 휴게소"
        stackView.rightLabel.text = "더보기"
        return stackView
    }()
    
    let parkingStatusStackView: LabelListStackView = {
        let stackView = LabelListStackView()
        stackView.leftLabel.text = "남은 주차 자릿수"
        return stackView
    }()
    
    var pagingIndex = 0
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
        view.backgroundColor = .backgroundColor
        view.contentInset = collectionViewContentInset
        view.register(NearAreaCollectionViewCell.self, forCellWithReuseIdentifier: NearAreaCollectionViewCell.id)
        return view
    }()
    
    let parkingStatusTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ParkingStatusTableViewCell.self, forCellReuseIdentifier: ParkingStatusTableViewCell.id)
        tableView.backgroundColor = .backgroundColor
        tableView.contentInset.top = 8
        tableView.contentInset.bottom = 35
        return tableView
    }()
    
    let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        return view
    }()
    
    let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .backgroundColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultsTableViewCell")
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        layout()
        searchViewSetUp()
        parkingManagerSetUp()
    }
    
    // MARK: SetUp
    func setUp() {
        self.view.backgroundColor = .backgroundColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingButtonClicked(_ :)))
        navigationItem.rightBarButtonItem?.tintColor = .secondaryColor
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "홈", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .primaryColor
        
        searchBar.delegate = self
        nearAreaCollectionView.delegate = self
        nearAreaCollectionView.dataSource = self
        parkingStatusTableView.delegate = self
        parkingStatusTableView.dataSource = self
    }
    
    // MARK: Layout
    func layout() {
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
        
        view.addSubview(nearAreaStackView)
        nearAreaStackView.addArrangedSubview(nearAreaCollectionView)

        view.addSubview(parkingStatusStackView)
        parkingStatusStackView.addArrangedSubview(parkingStatusTableView)
        
        nearAreaStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(80)
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

// MARK: SearchView SetUp, Functions
extension MainViewController {
    func searchViewSetUp() {
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
    }
    
    func showSearchView() {
        self.view.addSubview(self.searchView)
        self.searchView.addSubview(self.searchTableView)
        
        self.searchView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
            make.top.equalTo(self.searchBar.snp.bottom).offset(30)
        }

        self.searchTableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }

    func closeSearchView() {
        self.searchView.removeFromSuperview()
        self.searchTableView.removeFromSuperview()
        
        self.filteredServiceAreaNameList.removeAll()
        self.searchTableView.reloadData()
    }
}

// MARK: Button Action
extension MainViewController {
    @objc func settingButtonClicked(_ sender: UIBarButtonItem) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: API Response
extension MainViewController: APIManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateParking(_ parkingManager: APIManager, parking: ParkingData) {
        self.serviceAreaTotalInfoList = parking.data
        
        let serviceAreaNameArray = parking.data.map { $0.serviceArea }
        self.serviceAreaNameList = changeServiceAreaNameFormat(serviceAreaNameArray: serviceAreaNameArray)
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
            self.parkingStatusTableView.reloadData()
            self.nearAreaCollectionView.reloadData()
        }
    }
    
    func parkingManagerSetUp() {
        apiManager.delegate = self
        apiManager.fetchParking()
    }
    
    func changeServiceAreaNameFormat(serviceAreaNameArray: [String]) -> [ServiceAreaName] {
        var changedServiceAreaName = [ServiceAreaName]()
        
        for serviceAreaName in serviceAreaNameArray {
            if serviceAreaName.contains("(") {
                let nameWithLine = serviceAreaName.components(separatedBy: ["(", ")"])
                let name = nameWithLine[0]
                let line = nameWithLine[1]
                changedServiceAreaName.append(ServiceAreaName(name: name, line: line + " 방면"))
            } else {
                changedServiceAreaName.append(ServiceAreaName(name: serviceAreaName, line: ""))
            }
        }
        
        return changedServiceAreaName
    }
}

// MARK: UISearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        
        showSearchView()
        self.searchTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        updateSearchResults()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        
        dismissKeyboard()
        closeSearchView()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchTableView.reloadData()
    }
    
    func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults() {
        if let text = self.searchBar.text {
            self.filteredServiceAreaNameList = self.serviceAreaNameList.filter { $0.name.contains(text) }
        }
        
        self.searchTableView.reloadData()
    }
}

// MARK: UITableView Delegate, DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            return self.filteredServiceAreaNameList.count            
        } else if tableView == parkingStatusTableView {
            if serviceAreaTotalInfoList.isEmpty {
                return 0
            }
            
            return self.serviceAreaTotalInfoList[self.pagingIndex].numberOfCar.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath)
            
            cell.contentView.backgroundColor = .backgroundColor
            
            let filteredServiceArea = Array(self.filteredServiceAreaNameList)[indexPath.row]
            let name = filteredServiceArea.name
            let line = filteredServiceArea.line
            
            cell.textLabel?.text = "\(name) 휴게소 (\(line))"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            
            return cell
        } else if tableView == parkingStatusTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ParkingStatusTableViewCell.id, for: indexPath) as? ParkingStatusTableViewCell else {
                return UITableViewCell()
            }
            
            cell.carIconImageView.image = UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            
            if let image = CarType.allCases[indexPath.row].image {
                cell.carIconImageView.image = image
            }
            
            if serviceAreaTotalInfoList.isEmpty {
                return UITableViewCell()
            }
            
            cell.carLabel.text = CarType.allCases[indexPath.row].name
            cell.numberOfCarLabel.text = String(serviceAreaTotalInfoList[self.pagingIndex].numberOfCar[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return 60.0
        } else if tableView == parkingStatusTableView {
            return 100.0
        } else {
            return 0.0
        }
    }
}

// MARK: UICollectionView DataSource, DelegateFlowLayout
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.serviceAreaNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearAreaCollectionViewCell.id, for: indexPath) as? NearAreaCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // TODO: 샘플 데이터를 서버 데이터로 대체하는 작업 필요
        cell.profileImageView.image = UIImage(named: "샘플이미지")
        
        let index = self.serviceAreaNameList.index(self.serviceAreaNameList.startIndex, offsetBy: indexPath.row)
        cell.nameLabel.text = self.serviceAreaNameList[index].name
        cell.highwaylineLabel.text = self.serviceAreaNameList[index].line
        
        cell.lineTag.removeAllTags()
        cell.lineTag.addTags([self.serviceAreaTotalInfoList[indexPath.row].center, self.serviceAreaTotalInfoList[indexPath.row].line])
        
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
