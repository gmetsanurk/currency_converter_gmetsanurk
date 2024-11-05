import Combine
import Moya
import Foundation
import CombineMoya

public enum MyAppError: Error {
    case invalidUrl
    case networkError(additionalError: Error)
    case decodingError(additionalError: Error)
    case unknownError(additionalError: Error)
}

public protocol URLSessionProtocol {
    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    public func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}

public actor NetworkManager {
    
    private static let key: String = "VyF3jyMSwtoyS0GqlIV7c793tm4TJhvP"
    
    private var cancellables = Set<AnyCancellable>()
    private var networkSession: URLSessionProtocol
    
    public init(networkSession: URLSessionProtocol = URLSession.shared) {
        self.networkSession = networkSession
    }
    
    public func getCurrencyData() async throws -> Currencies {
        var token: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<CurrencyAPI>()
            token = provider.requestPublisher(.list)
                .tryMap { response in
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: MyAppError.networkError(additionalError: URLError(.badServerResponse)))
                        throw URLError(.badServerResponse)
                    }
                    return response.data
                }
                .decode(type: Currencies.self, decoder: JSONDecoder())
                .mapError { error -> MyAppError in
                    if let urlError = error as? URLError {
                        return MyAppError.networkError(additionalError: urlError)
                    } else if let decodingError = error as? DecodingError {
                        return MyAppError.decodingError(additionalError: decodingError)
                    } else {
                        return MyAppError.unknownError(additionalError: error)
                    }
                }
                .sink(receiveCompletion: {
                    switch $0 {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        token = nil
                    case .finished:
                        break
                    }
                }, receiveValue: {
                    continuation.resume(returning: $0)
                    token = nil
                })
        }
    }
    
    public func convertCurrencyData(to: String, from: String, amount: Int) async throws -> ConvertCurrency {
        var token: AnyCancellable?
        return try await withCheckedThrowingContinuation { continuation in
            let provider = MoyaProvider<CurrencyAPI>()
            token = provider.requestPublisher(.convert(to: to, from: from, amount: amount))
                .tryMap { response in
                    guard (200...299).contains(response.statusCode) else {
                        continuation.resume(throwing: MyAppError.networkError(additionalError: URLError(.badServerResponse)))
                        throw URLError(.badServerResponse)
                    }
                    return response.data
                }
                .decode(type: ConvertCurrency.self, decoder: JSONDecoder())
                .mapError { error -> MyAppError in
                    if let urlError = error as? URLError {
                        return MyAppError.networkError(additionalError: urlError)
                    } else if let decodingError = error as? DecodingError {
                        return MyAppError.decodingError(additionalError: decodingError)
                    } else {
                        return MyAppError.unknownError(additionalError: error)
                    }
                }
                .sink(receiveCompletion: {
                    switch $0 {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                        token = nil
                    case .finished:
                        break
                    }
                }, receiveValue: { (convertedCurrency: ConvertCurrency) in
                    continuation.resume(returning: convertedCurrency)
                    token = nil
                })
        }
    }
}

extension NetworkManager {
    enum CurrencyAPI: TargetType {
        case list
        case convert(to: String, from: String, amount: Int)
        
        var baseURL: URL {
            return URL(string: "https://api.apilayer.com")!
        }
        var path: String {
            switch self {
            case .list:
                return "/currency_data/list"
            case .convert:
                return "/currency_data/convert"
            }
        }
        var method: Moya.Method {
            return .get
        }
        var task: Task {
            switch self {
            case .list:
                return .requestPlain
            case .convert(let to, let from, let amount):
                return .requestParameters(parameters: [
                    "to": to,
                    "from": from,
                    "amount": amount
                ], encoding: URLEncoding.default)
            }
        }
        var headers: [String: String]? {
            return ["apikey": key]
        }
        var validationType: ValidationType {
            return .successCodes
        }
    }
}
