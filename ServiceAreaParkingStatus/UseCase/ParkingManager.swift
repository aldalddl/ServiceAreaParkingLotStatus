//
//  ParkingLotStatusManager.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/21.
//

import Foundation

protocol ParkingManagerDelegate {
    func didUpdateParking(_ parkingManager: ParkingManager, parking: ParkingData)
    func didFailWithError(error: Error)
}

struct ParkingManager {
    let url = "https://api.odcloud.kr/api/15043716/v1"
    let uddi = "/uddi:82a523ae-4e2d-4c59-9371-93fece61d290"
    let pageIndex = "?page=1"
    let pageSize = "&perPage=10"
    let serviceKey = "&serviceKey=ZtyZh2K9tt4JLRmlA0TvcdtHtrwlCQkAXMKJgx2jix27OviIlHsx4NGS1nn3OnYN5v9v3niuEpt2UaKUDdC9cw%3D%3D"
    
    var delegate: ParkingManagerDelegate?
    
    func fetchParking() {
        let urlString = url + uddi + pageIndex + pageSize + serviceKey
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let parking = self.parseJSON(safeData) {
                        self.delegate?.didUpdateParking(self, parking: parking)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ parkingData: Data) -> ParkingData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ParkingData.self, from: parkingData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
