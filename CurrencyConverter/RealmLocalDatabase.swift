import Dispatch
import RealmSwift
import NetworkManager

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
                    RealmCurrency(code: $0.key, fullName: $0.value)
                })
            }
        }
    }

    func loadCurrencies(completion: @escaping (Currencies) -> Void) {
        DispatchQueue.main.async {
            guard let realm = try? Realm() else {
                return
            }
            let resultsArray: Results<RealmCurrency> = realm.objects(RealmCurrency.self)
            completion(Currencies.init(
            currencies: .init(resultsArray.map {
                ($0.code, $0.fullName)
            }, uniquingKeysWith: { first, _ in first }), success: true))
        }
    }

    var isEmptyCurrencies: Bool {
        (try? Realm().isEmpty) ?? true
    }
}
