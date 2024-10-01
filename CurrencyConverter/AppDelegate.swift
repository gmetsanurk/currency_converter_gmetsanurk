import UIKit
import Swinject
import RealmSwift

//let homeScreen = HomeViewController()
//let selectCurrenciesScreen = SelectCurrencyScreen()

protocol LocalDatabase {
    func save(currencies: Currencies)
    func loadCurrencies(completion: @escaping (Currencies) -> Void)
}

struct RealmLocalDatabase {

}

extension RealmLocalDatabase: LocalDatabase {
    func save(currencies: Currencies) {
        DispatchQueue.main.async {
            guard let realm = try? Realm() else {
                return
            }
            try? realm.write {
                realm.add(currencies.currencies.map {
                    Currency(code: $0.key, fullName: $0.value)
                })
            }
        }
    }

    func loadCurrencies(completion: @escaping (Currencies) -> Void) {
        DispatchQueue.main.async {
            guard let realm = try? Realm() else {
                return
            }
            let resultsArray: Results<Currency> = realm.objects(Currency.self)
            completion(Currencies.init(
            currencies: .init(resultsArray.map {
                ($0.code, $0.fullName)
            }, uniquingKeysWith: { first, _ in first }), success: true))
        }
    }
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
