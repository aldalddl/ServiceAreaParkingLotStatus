//
//  ViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let searchViewController = UISearchController(searchResultsController: nil)
    var parkingArray = [Parking]()
    var filteredServiceAreaArray = [String]()
    var serviceAreaArray = [String]()
    var largeCarCount = Int()
    var smallCarCount = Int()
    var disabledCarCount = Int()
    var isFiltering: Bool {
        let searchViewController = self.navigationItem.searchController
        let isActive = searchViewController?.isActive ?? false
        let isSearchBarHasText = searchViewController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    var parkingManager = ParkingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
    
        searchControllerSetup()
        tableViewSetup()
        tableViewLayout()
        parkingManagerSetup()
        
    }
    
    // MARK: Setup
    func searchControllerSetup() {
        self.navigationItem.searchController = searchViewController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 0.4314983444)
        navigationItem.title = "휴게소 주차 현황"
        searchViewController.searchBar.placeholder = "휴게소 이름 입력"
        searchViewController.searchResultsUpdater = self
    }
    
    func tableViewSetup() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    // MARK: Layout
    func tableViewLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
    }
    
}

// MARK: API Response
extension ViewController: ParkingManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateParking(_ parkingManager: ParkingManager, parking: ParkingData) {
        
        self.serviceAreaArray = parking.data.map{ String($0.휴게소명) }
        self.parkingArray = parking.data
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
//        dump(self.filteredTextArray)
        
        self.tableView.reloadData()
    }
}

// MARK: UITableView Delegate, DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return self.filteredServiceAreaArray.count
        } else {
            return self.serviceAreaArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        cell.backgroundColor = #colorLiteral(red: 0.757620573, green: 0.6714900136, blue: 0.9552794099, alpha: 0.4531767384)
        
        if isFiltering {
            cell.textLabel?.text = self.filteredServiceAreaArray[indexPath.row]
        } else {
            cell.textLabel?.text = self.serviceAreaArray[indexPath.row]
        }
        
        return cell
    }
}
