import Dispatch
import RealmSwift
import NetworkManager

actor RealmLocalDatabase {

}

extension RealmLocalDatabase: LocalDatabase {
    func save(currencies: Currencies) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(currencies.currencies.map {
                        RealmCurrency(code: $0.key, fullName: $0.value)
                    })
                }
                continuation.resume(returning: ())
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func loadCurrencies() async throws -> Currencies {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let realm = try Realm()
                let resultsArray: Results<RealmCurrency> = realm.objects(RealmCurrency.self)
                
                let currencies = Currencies(
                    currencies: .init(resultsArray.map {
                        ($0.code, $0.fullName)
                    }, uniquingKeysWith: { first, _ in first }),
                    success: true
                )
                continuation.resume(returning: (currencies))
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func isEmptyCurrencies() async -> Bool {
        return await Task { @MainActor in
            (try? await Realm().isEmpty) ?? true
        }.value
    }
}
