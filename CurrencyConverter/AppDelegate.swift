import UIKit
import Swinject
import CoreData
import NetworkManager

//let homeScreen = HomeViewController()
//let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase {
    func save(currencies: Currencies)
    func loadCurrencies(completion: @escaping (Currencies) -> Void)
    var isEmptyCurrencies: Bool { get }
}

protocol RemoteDataSource {
    func getCurrencyData() async throws -> Currencies
}

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
