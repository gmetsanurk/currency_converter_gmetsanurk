import UIKit
import Swinject
import CoreData
import NetworkManager

//let homeScreen = HomeViewController()
//let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase: Actor {
    func save(currencies: Currencies) async throws
    func loadCurrencies() async throws -> Currencies
    func isEmptyCurrencies() async -> Bool
}

protocol RemoteDataSource: Actor {
    func getCurrencyData() async throws -> Currencies
}

actor Dependencies {
    let container = {
        let container = Container()
        container.register(LocalDatabase.self) { _ in
            // CoreDataManager.shared
            RealmLocalDatabase()
        }
        container.register(RemoteDataSource.self) { _ in
            //NetworkManager()
            LocalManager()
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
