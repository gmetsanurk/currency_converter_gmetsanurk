import Dispatch
import RealmSwift

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
