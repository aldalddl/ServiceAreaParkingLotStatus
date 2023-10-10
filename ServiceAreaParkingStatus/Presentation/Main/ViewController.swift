//
//  ViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
//    let tableView = UITableView()
    let resultTableViewController = ResultTableViewController()
    var searchViewController = UISearchController()
    var serviceAreaArray = [String]()
    var filteredServiceAreaArray = [String]()
    var parkingLotArray = [Parking]()
    var parkingManager = ParkingManager()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        searchControllerSetup()
        parkingManagerSetup()
    }
    
    // MARK: Setup
    func setup() {
        self.view.backgroundColor = .systemBackground
        searchViewController = UISearchController(searchResultsController: resultTableViewController)
        resultTableViewController.tableView.delegate = self
    }
    
    func searchControllerSetup() {
        self.navigationItem.searchController = searchViewController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(clickSettingButton(_ :)))
        
        searchViewController.searchBar.placeholder = "휴게소 이름 입력"
        searchViewController.searchResultsUpdater = self
    }
        
    @objc func clickSettingButton(_ sender: UIBarButtonItem) {
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
        self.resultTableViewController.parkingLotArray = parking.data
        
        DispatchQueue.main.async {
            self.resultTableViewController.tableView.reloadData()
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
        
        if let resultVC = searchController.searchResultsController as? ResultTableViewController {
            resultVC.filteredServiceAreaArray = self.filteredServiceAreaArray
            resultVC.tableView.reloadData()
        }
    }
}

// MARK: UITableView Delegate, DataSource
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if isFiltering {
            count = self.resultTableViewController.filteredServiceAreaArray.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if isFiltering {
            cell.textLabel?.text = self.resultTableViewController.filteredServiceAreaArray[indexPath.row]
        }
        
        return cell
    }
}
