import UIKit
import Swinject
import RealmSwift

//let homeScreen = HomeViewController()
//let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase {
    func save(currencies: Currencies)
    func loadCurrencies(completion: @escaping (Currencies) -> Void)
}

let container = {
    let container = Container()
    container.register(LocalDatabase.self) { _ in
        RealmLocalDatabase()
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
