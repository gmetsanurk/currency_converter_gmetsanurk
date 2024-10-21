import Combine
import Foundation

enum MyAppError: Error {
    case invalidUrl
    case networkError(additionalError: Error)
}

public actor NetworkManager {

    private var key: String = "VyF3jyMSwtoyS0GqlIV7c793tm4TJhvP"
    
    private var cancellables = Set<AnyCancellable>()

    public init() {

    }

    func getCurrencyData() async throws -> Currencies {
        var urlComponents = URLComponents(string: "https://api.apilayer.com")!
        urlComponents.path = "/currency_data/list"
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            throw MyAppError.invalidUrl
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(key, forHTTPHeaderField: "apikey")

        return try await withCheckedThrowingContinuation { continuation in
            var publisher: AnyCancellable?
            publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Currencies.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { status in
                    switch status {
                    case .finished:
                        publisher = nil
                        print("Request completed successfully")
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        continuation.resume(throwing: MyAppError.networkError(additionalError: error))
                    }
                },
                receiveValue: { currencies in
                    print("Data received: \(currencies)")
                    continuation.resume(returning: currencies)
                }
            )
        }
    }

    public func convertCurrencyData(to: String, from: String, amount: Int) async throws -> ConvertCurrency {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.apilayer.com"
        urlComponents.path = "/currency_data/convert"
        urlComponents.queryItems = [
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL")
            throw MyAppError.invalidUrl
        }

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        await request.addValue(key, forHTTPHeaderField: "apikey")

        return try await withCheckedThrowingContinuation { continuation in
            var publisher: AnyCancellable?
            publisher = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: ConvertCurrency.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { status in
                    switch status {
                    case .finished:
                        print("Request completed successfully")
                        publisher = nil
                    case .failure(let error):
                        print("Request failed with error: \(error)")
                        continuation.resume(throwing: MyAppError.networkError(additionalError: error))
                    }
                },
                receiveValue: { convertedCurrency in
                    print("Data received: \(convertedCurrency)")
                    continuation.resume(returning: convertedCurrency)
                }
            )
        }
    }

}
