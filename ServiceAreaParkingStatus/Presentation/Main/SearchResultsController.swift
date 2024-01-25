//
//  ResultTableViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/09.
//

import Foundation
import UIKit

class SearchResultsController: UIViewController {
    let tableView = UITableView()
    var filteredServiceAreaArray = [String]()
    var parkingDataArray = [ParkingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        tableViewSetUp()
        layout()
    }
    
    // MARK: SetUp
    func setUp() {
        view.backgroundColor = .systemBackground
    }
    
    func tableViewSetUp() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultsTableViewCell")
    }
    
    // MARK: Layout
    func layout() {
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

// MARK: UITableView DataSource
extension SearchResultsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredServiceAreaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredServiceAreaArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searceViewController = SearchViewController()
        
        searceViewController.carCountArray.append(self.parkingDataArray[indexPath.row].large)
        searceViewController.carCountArray.append(self.parkingDataArray[indexPath.row].small)
        searceViewController.carCountArray.append(self.parkingDataArray[indexPath.row].disbled)
        searceViewController.highwayLine.append(self.parkingDataArray[indexPath.row].line)
        searceViewController.highwayCenter.append(self.parkingDataArray[indexPath.row].center)
        
        self.navigationController?.pushViewController(searceViewController, animated: true)
    }
}
