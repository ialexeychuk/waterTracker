//
//  NetworkModel.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 04.07.2023.
//

import Foundation


class NetworkModel {
    
    var onCompelition: ((FactData) -> Void)?
    
    //MARK: Fetching fact from the internet
    func fetchFact() {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/facts?limit=1") else { return }
        var request = URLRequest(url: url)
        request.setValue("HERE MUST BE YOUR API KEY", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }
            
            if let fact = self?.parseJSON(withData: data) {
                self?.onCompelition?(fact)
            }
            
        }
        task.resume()
        
        
    }
    
    
    //MARK: Parsing JSON
    func parseJSON(withData data: Data) -> FactData? {
        let decoder = JSONDecoder()
        
        do {
            let fact = try decoder.decode([FactData].self, from: data)
            
            return fact.first
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
