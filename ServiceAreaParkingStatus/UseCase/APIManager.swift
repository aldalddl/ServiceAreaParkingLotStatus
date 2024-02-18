//
//  ParkingLotStatusManager.swift
//  ServiceAreaParkingStatus
//
//  Created by 강민지 on 2023/09/21.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdateParking(_ parkingManager: APIManager, parking: ParkingData)
    func didFailWithError(error: Error)
}

struct APIManager {
    
    let key = Bundle.main.apiKey
    var url = "https://api.odcloud.kr/api/15043716/v1/uddi:82a523ae-4e2d-4c59-9371-93fece61d290?page=1&perPage=12"
    var delegate: APIManagerDelegate?
    
    func fetchParking() {
        let urlString = url + "&serviceKey=\(key)"
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
