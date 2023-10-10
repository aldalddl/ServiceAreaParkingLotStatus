//
//  ResultTableViewController.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/10/09.
//

import Foundation
import UIKit

class ResultTableViewController: UIViewController {
    let tableView = UITableView()
    var filteredServiceAreaArray = [String]()
    var parkingLotArray = [Parking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        tableViewSetup()
        tableViewLayout()
    }
    
    func setup() {
        view.backgroundColor = .systemBackground
    }
    
    func tableViewSetup() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
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

// MARK: UITableView DataSource
extension ResultTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredServiceAreaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = self.filteredServiceAreaArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searceViewController = SearchViewController()
        
        searceViewController.carCountArray.append(self.parkingLotArray[indexPath.row].대형)
        searceViewController.carCountArray.append(self.parkingLotArray[indexPath.row].소형)
        searceViewController.carCountArray.append(self.parkingLotArray[indexPath.row].장애인)
        searceViewController.highwayLine.append(self.parkingLotArray[indexPath.row].노선.rawValue)
        searceViewController.highwayCenter.append(self.parkingLotArray[indexPath.row].본부.rawValue)
        
        self.navigationController?.pushViewController(searceViewController, animated: true)
    }
}
