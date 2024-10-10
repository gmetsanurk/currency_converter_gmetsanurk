import Foundation

class NetworkManager {
    
    private var key: String = "VyF3jyMSwtoyS0GqlIV7c793tm4TJhvP"
    
    public func getCurrencyData(completion: @escaping (Currencies?) -> Void) {
        var urlComponents = URLComponents(string: "https://api.apilayer.com")
        urlComponents?.path = "/currency_data/list"
        let url = urlComponents?.string ?? ""
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "apikey")
        
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
    
    public func convertCurrencyData(to: String, from: String, amount: Int, completion: @escaping (ConvertCurrency?) -> Void){
        let url = "https://api.apilayer.com/currency_data/convert?to=\(to)&from=\(from)&amount=\(amount)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let receivedString = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            print(receivedString)
            
            let result = try? JSONDecoder().decode(ConvertCurrency.self, from: data)
            completion(result)
        }

        task.resume()
    }
}
