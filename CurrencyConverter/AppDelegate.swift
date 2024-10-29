import UIKit
import Swinject
import CoreData
import NetworkManager
import Combine

//let homeScreen = HomeViewController()
//let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase: Actor {
    func save(currencies: Currencies) async throws
    func loadCurrencies() async throws -> Currencies
    func isEmptyCurrencies() async -> Bool
}

protocol RemoteDataSource: Actor {
    func getCurrencyData() async throws -> Currencies
    func convertCurrencyData(to: String, from: String, amount: Int) async throws -> ConvertCurrency
}

extension NetworkManager: RemoteDataSource { }

class MyMockSession: URLSessionProtocol {
    public var mockData: Data?
    public var mockResponse: HTTPURLResponse?
    public var error: URLError?
    
    func dataTaskAnyPublisher(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse()
        
        return Just((data: data, response: response))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
}

actor Dependencies {
    let container = {
        let container = Container()
        container.register(LocalDatabase.self) { _ in
            // CoreDataManager.shared
            RealmLocalDatabase()
        }
        container.register(RemoteDataSource.self) { _ in
            NetworkManager.init(networkSession: MyMockSession())
            //LocalManager()
        }
        return container
    }()

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }
}

let dependencies = Dependencies()

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupWindow()
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()
    }
}
