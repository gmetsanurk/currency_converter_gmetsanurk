//
//  NetworkManager.swift
//  CurrentConverterApp
//
//  Created by Georgy on 2024-09-27.
//

import Foundation

class NetworkManager {
    
    public func getCurrencyData(completion: @escaping (Currencies?) -> Void) {
        let url = "https://api.apilayer.com/currency_data/list"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("VyF3jyMSwtoyS0GqlIV7c793tm4TJhvP", forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(nil)
                return
            }
            guard let receivedString = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            print(receivedString)

            let result = try? JSONDecoder().decode(Currencies.self, from: data)
            completion(result)
        }
        
        task.resume()
    }
}
