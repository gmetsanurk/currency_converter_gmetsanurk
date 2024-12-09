import Combine
import CoreData
import NetworkManager
import SwiftUI
import Swinject
import UIKit

// let homeScreen = HomeViewController()
// let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase: Actor {
    func save(currencies: Currencies) async throws
    func loadCurrencies() async throws -> Currencies
    func isEmptyCurrencies() async -> Bool
}

protocol RemoteDataSource: Actor {
    func getCurrencyData() async throws -> Currencies
    func convertCurrencyData(to: String, from: String, amount: Int) async throws -> ConvertCurrency
}

extension NetworkManager: RemoteDataSource {}

actor Dependencies {
    let container = {
        let container = Container()
        container.register(LocalDatabase.self) { _ in
            // CoreDataManager.shared
            RealmLocalDatabase()
        }
        container.register(RemoteDataSource.self) { _ in
            // NetworkManager()
            // NetworkManager.init(networkSession: MyMockSession())
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

        /*
         let homeViewSwiftUI = HomeViewSwiftUI()
         let hostingController = HomeViewSwiftUIController(rootView: homeViewSwiftUI)

         window?.rootViewController = HomeView()
         // window?.rootViewController = hostingController

         window?.makeKeyAndVisible()
         */
        dependencies.container.register(Coordinator.self) { [weak self] _ in
            UIKitCoordinator(window: self?.window ?? .init())
        }
        dependencies.resolve(Coordinator.self)?.openHomeScreen()
    }
}
